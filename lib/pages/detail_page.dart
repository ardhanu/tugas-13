import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tugas_13_flutter/const/app_color.dart';
import 'package:tugas_13_flutter/database/db_helper.dart';
import 'package:tugas_13_flutter/models/resep_model.dart';
import 'package:tugas_13_flutter/pages/edit_data_page.dart';

class DetailPage extends StatefulWidget {
  final String heroTag;
  final ResepModel resep;

  const DetailPage({Key? key, required this.heroTag, required this.resep})
    : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    muatData();
  }

  Future<void> muatData() async {
    try {
      final List<ResepModel> data = await DatabaseHelper.getAllData();
      if (mounted) {
        setState(() {
          // Update the current resep with the latest data
          final updatedResep = data.firstWhere(
            (r) => r.id == widget.resep.id,
            orElse: () => widget.resep,
          );
          widget.resep.name = updatedResep.name;
          widget.resep.description = updatedResep.description;
          widget.resep.steps = updatedResep.steps;
          widget.resep.kategori = updatedResep.kategori;
          widget.resep.waktu = updatedResep.waktu;
          widget.resep.imageUrl = updatedResep.imageUrl;
          widget.resep.isFavorite = updatedResep.isFavorite;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memuat data: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      appBar: AppBar(
        backgroundColor: AppColor.secondary,
        foregroundColor: Colors.white,
        title: Text('Detail Resep', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditDataPage(resep: widget.resep),
                ),
              );
              if (result == true) {
                await muatData();
                Navigator.pop(
                  context,
                  true,
                ); // Return true to refresh home page
              }
            },
            icon: Icon(Icons.edit, size: 20),
          ),
          IconButton(
            onPressed: () async {
              try {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        backgroundColor: AppColor.accent,
                        title: Text(
                          'Hapus Resep',
                          style: TextStyle(color: Colors.white),
                        ),
                        content: Text(
                          'Apakah Anda yakin ingin menghapus resep "${widget.resep.name}"?',
                          style: TextStyle(color: Colors.white),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(
                              'Batal',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text(
                              'Hapus',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                );

                if (confirmed == true && mounted) {
                  await DatabaseHelper.deleteData(widget.resep.id!);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Resep berhasil dihapus'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(
                      context,
                      true,
                    ); // Return true to indicate deletion
                  }
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal menghapus resep: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            icon: Icon(Icons.delete, size: 20),
          ),
        ],
      ),
      body:
          widget.resep.id == null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 80,
                      color: Colors.white.withOpacity(0.5),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Resep tidak ditemukan',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Resep mungkin telah dihapus atau tidak tersedia',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
              : Column(
                children: [
                  Hero(
                    tag: widget.heroTag,
                    child: Stack(
                      children: [
                        ClipRRect(
                          child: Image.file(
                            File(
                              widget.resep.imageUrl ??
                                  'assets/images/no_image_found.jpg',
                            ),
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColor.primary,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                widget.resep.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color:
                                    widget.resep.isFavorite
                                        ? Colors.red
                                        : Colors.white,
                              ),
                              onPressed: () async {
                                try {
                                  setState(() {
                                    widget.resep.isFavorite =
                                        !widget.resep.isFavorite;
                                  });
                                  await DatabaseHelper.toggleFavorite(
                                    widget.resep.id!,
                                    widget.resep.isFavorite,
                                  );
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          widget.resep.isFavorite
                                              ? 'Resep ditambahkan ke favorit'
                                              : 'Resep dihapus dari favorit',
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    Navigator.pop(
                                      context,
                                      true,
                                    ); // Return true to refresh home page
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    setState(() {
                                      widget.resep.isFavorite =
                                          !widget
                                              .resep
                                              .isFavorite; // Revert the change
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Gagal mengubah status favorit: $e',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: ListView(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _buildContainerDetails(
                                icon: Icons.timer_outlined,
                                height: 20,
                                width: 80,
                                color: AppColor.addOns,
                                label: '${widget.resep.waktu} Menit',
                              ),
                              SizedBox(width: 4),
                              _buildContainerDetails(
                                icon: Icons.category_outlined,
                                height: 20,
                                width: 80,
                                color: AppColor.addOns2,
                                label: widget.resep.kategori,
                              ),
                            ],
                          ),
                          Text(
                            widget.resep.name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            widget.resep.description,
                            style: TextStyle(fontSize: 14, color: Colors.white),
                            textAlign: TextAlign.justify,
                          ),
                          Divider(),
                          Text(
                            'Langkah memasak:',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Text(
                              widget.resep.steps,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  Container _buildContainerDetails({
    required Color color,
    required String label,
    required double height,
    required double width,
    required IconData icon,
  }) {
    return Container(
      height: height,
      width: width,
      margin: EdgeInsets.only(left: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 14),
          SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, color: color)),
        ],
      ),
    );
  }
}
