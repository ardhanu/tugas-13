import 'package:flutter/material.dart';
import 'package:tugas_13_flutter/const/app_color.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recips adalah aplikasi resep masakan yang memungkinkan pengguna untuk menyimpan, mengelola, dan berbagi resep masakan favorit mereka. Aplikasi ini dirancang dengan antarmuka yang intuitif dan mudah digunakan, memungkinkan pengguna untuk menambahkan resep baru, mengedit resep yang ada, dan menandai resep favorit mereka.",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 14),
            Text(
              "Fitur Utama:\n• Tambah dan edit resep\n• Simpan resep favorit\n• Cari resep berdasarkan nama atau deskripsi\n• Tampilkan detail resep lengkap\n• Antarmuka yang mudah digunakan",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 14),
            Text.rich(
              TextSpan(
                text: "© 2025 Recips. All rights reserved.\nDikembangkan oleh ",
                style: TextStyle(color: Colors.white70),
                children: [
                  TextSpan(
                    text: "ardhanu",
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " menggunakan Flutter",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14),
            Text('Versi 1.0.0', style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
