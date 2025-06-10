import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tugas_13_flutter/database/db_helper.dart';

import '../const/app_color.dart';
import '../models/resep_model.dart';

class TambahDataPage extends StatefulWidget {
  const TambahDataPage({super.key});

  @override
  State<TambahDataPage> createState() => _TambahDataPageState();
}

class _TambahDataPageState extends State<TambahDataPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _langkahController = TextEditingController();
  final _kategoriController = TextEditingController();
  final _waktuController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  void _simpanResep() async {
    if (_formKey.currentState!.validate()) {
      final resep = ResepModel(
        name: _namaController.text,
        description: _deskripsiController.text,
        steps: _langkahController.text,
        kategori: _kategoriController.text,
        waktu: _waktuController.text,
        imageUrl: _imageFile?.path,
      );
      await DatabaseHelper.simpanData(resep);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      appBar: AppBar(
        title: const Text(
          'Tambah Resep',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColor.secondary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor.accent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      _imageFile != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _imageFile!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                          : const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image, color: Colors.white),
                                SizedBox(height: 8),
                                Text(
                                  'Pilih Gambar',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                ),
              ),
              const SizedBox(height: 16),
              _buildField(_namaController, 'Nama Resep'),
              _buildField(_deskripsiController, 'Deskripsi'),
              _buildField(_langkahController, 'Langkah Memasak', maxLines: 5),
              _buildField(_kategoriController, 'Kategori'),
              _buildField(_waktuController, 'Waktu Memasak'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _simpanResep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.secondary,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String hintText, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColor.accent,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
