import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tugas_13_flutter/const/app_color.dart';
import 'package:tugas_13_flutter/database/db_helper.dart';
import 'package:tugas_13_flutter/models/resep_model.dart';
import 'package:tugas_13_flutter/pages/detail_page.dart';
import 'package:tugas_13_flutter/pages/informasi_page.dart';
import 'package:tugas_13_flutter/pages/tambah_data_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _totalResep = 0;
  int _totalFavorite = 0;
  final TextEditingController _searchController = TextEditingController();
  List<ResepModel> daftarResep = [];
  List<ResepModel> _filteredResep = [];

  @override
  void initState() {
    super.initState();
    muatData();
    _searchController.addListener(_searchResep);
    _muatTotalFavorite();
  }

  Future<void> muatData() async {
    final data = await DatabaseHelper.getAllData();
    final jumlah = await DatabaseHelper.getTotalResep();
    setState(() {
      daftarResep = data;
      _filteredResep = data;
      _totalResep = jumlah;
    });
  }

  void _searchResep() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredResep =
          daftarResep.where((resep) {
            return resep.name.toLowerCase().contains(query) ||
                resep.description.toLowerCase().contains(query);
          }).toList();
    });
  }

  Future<void> _muatTotalFavorite() async {
    int total = await DatabaseHelper.countFavorite();
    setState(() {
      _totalFavorite = total;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColor.accent,
            hintText: 'Cari resep...',
            hintStyle: TextStyle(color: Colors.white),
            prefixIcon: Icon(Icons.search, color: Colors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          ),
        ),
        SizedBox(height: 12),
        Card(
          elevation: 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: AppColor.accent,
              height: 100,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                height: 30,
                                width: 65,
                                color: AppColor.secondary,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.book,
                                      color: Colors.blueAccent,
                                      size: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '$_totalResep',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Jumlah Resep',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  VerticalDivider(
                    color: Colors.white.withOpacity(0.5),
                    thickness: 1,
                    width: 32,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        print('Resep Favorit diklik');
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  height: 30,
                                  width: 65,
                                  color: AppColor.secondary,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 16,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '${_totalFavorite}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Resep Favorit',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredResep.length,
            itemBuilder: (BuildContext context, int index) {
              final resep = _filteredResep[index];
              return Card(
                color: AppColor.accent,
                elevation: 4,
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => DetailPage(
                              heroTag: 'resep_$index',
                              resep: resep,
                            ),
                      ),
                    );
                  },
                  leading: Hero(
                    tag: 'resep_$index',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(
                          resep.imageUrl ?? 'assets/images/no_image_found.jpg',
                        ),
                        height: 75,
                        width: 75,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    resep.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resep.description,
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          _buildContainerDetails(
                            icon: Icons.timer_outlined,
                            height: 20,

                            color: AppColor.addOns,
                            label: '${resep.waktu} Menit',
                          ),
                          SizedBox(width: 4),
                          _buildContainerDetails(
                            icon: Icons.category_outlined,
                            height: 20,

                            color: AppColor.addOns2,
                            label: '${resep.kategori}',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      appBar: AppBar(
        title: Text('Recips', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: AppColor.secondary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _selectedIndex == 0 ? _buildHomeContent() : AboutUs(),
      ),
      floatingActionButton:
          _selectedIndex == 0
              ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TambahDataPage()),
                  ).then((_) => muatData());
                },
                backgroundColor: AppColor.secondary,
                child: Icon(Icons.add, color: Colors.white),
              )
              : null,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColor.secondary,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _buildContainerDetails({
    required Color color,
    required String label,
    required double height,
    required IconData icon,
  }) {
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
