import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tugas_13_flutter/database/db_helper.dart';

import '../const/app_color.dart';
import '../models/resep_model.dart';

class EditDataPage extends StatefulWidget {
  final ResepModel resep;

  const EditDataPage({super.key, required this.resep});

  @override
  State<EditDataPage> createState() => _EditDataPageState();
}

class _EditDataPageState extends State<EditDataPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _deskripsiController;
  late TextEditingController _langkahController;
  late TextEditingController _kategoriController;
  late TextEditingController _waktuController;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.resep.name);
    _deskripsiController = TextEditingController(
      text: widget.resep.description,
    );
    _langkahController = TextEditingController(text: widget.resep.steps);
    _kategoriController = TextEditingController(text: widget.resep.kategori);
    _waktuController = TextEditingController(text: widget.resep.waktu);
  }

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  void _updateResep() async {
    if (_formKey.currentState!.validate()) {
      final updatedResep = ResepModel(
        id: widget.resep.id,
        name: _namaController.text.trim(),
        description: _deskripsiController.text.trim(),
        steps: _langkahController.text.trim(),
        kategori: _kategoriController.text.trim(),
        waktu: _waktuController.text.trim(),
        imageUrl: _imageFile != null ? _imageFile!.path : widget.resep.imageUrl,
        isFavorite: widget.resep.isFavorite,
      );

      try {
        await DatabaseHelper.updateData(updatedResep);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Resep berhasil diperbarui')),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memperbarui resep: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      appBar: AppBar(
        title: const Text('Edit Resep', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.secondary,
        foregroundColor: Colors.white,
        actions: [IconButton(onPressed: _updateResep, icon: Icon(Icons.check))],
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
                          : widget.resep.imageUrl != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(widget.resep.imageUrl!),
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
