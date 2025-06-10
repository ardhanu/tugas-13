// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ResepModel {
  int? id;
  String name;
  String description;
  String steps;
  String kategori;
  String waktu;
  String? imageUrl;
  bool isFavorite;

  ResepModel({
    this.id,
    required this.name,
    required this.description,
    required this.steps,
    required this.kategori,
    required this.waktu,
    this.imageUrl,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'steps': steps,
      'kategori': kategori,
      'waktu': waktu,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory ResepModel.fromMap(Map<String, dynamic> map) {
    return ResepModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
      description: map['description'] as String,
      steps: map['steps'] as String,
      kategori: map['kategori'] as String,
      waktu: map['waktu'] as String,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      isFavorite: map['isFavorite'] == 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory ResepModel.fromJson(String source) =>
      ResepModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
