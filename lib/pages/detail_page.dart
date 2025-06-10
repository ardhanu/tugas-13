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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      appBar: AppBar(
        backgroundColor: AppColor.secondary,
        foregroundColor: Colors.white,
        title: Text('Detail Resep', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditDataPage(resep: widget.resep),
                ),
              );
            },
            icon: Icon(Icons.edit, size: 20),
          ),
          IconButton(
            onPressed: () {
              // Tambahkan aksi hapus jika diperlukan
            },
            icon: Icon(Icons.delete, size: 20),
          ),
        ],
      ),
      body: Column(
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
                            widget.resep.isFavorite ? Colors.red : Colors.white,
                      ),
                      onPressed: () async {
                        setState(() {
                          widget.resep.isFavorite = !widget.resep.isFavorite;
                        });
                        await DatabaseHelper.toggleFavorite(
                          widget.resep.id!,
                          widget.resep.isFavorite,
                        );
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
                        label: '15 Menit',
                      ),
                      SizedBox(width: 4),
                      _buildContainerDetails(
                        icon: Icons.category_outlined,
                        height: 20,
                        width: 80,
                        color: AppColor.addOns2,
                        label: 'Nasi',
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
                      style: TextStyle(fontSize: 14, color: Colors.white),
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
