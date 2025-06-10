import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/resep_model.dart';

class DatabaseHelper {
  static Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'resep.db'),
      version: 2,
      onCreate: (db, version) {
        return db.execute('''
      CREATE TABLE daftar_resep (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        steps TEXT,
        kategori TEXT,
        waktu TEXT,
        imageUrl TEXT,
        isFavorite INTEGER DEFAULT 0
      );
    ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE daftar_resep ADD COLUMN waktu TEXT;');
          await db.execute(
            'ALTER TABLE daftar_resep ADD COLUMN imageUrl TEXT;',
          );
          await db.execute(
            'ALTER TABLE daftar_resep ADD COLUMN isFavorite INTEGER DEFAULT 0;',
          );
        }
      },
    );
  }

  static Future<void> toggleFavorite(int id, bool isFavorite) async {
    final db = await initDB();
    await db.update(
      'daftar_resep',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> countFavorite() async {
    final db = await initDB();
    final result = await db.rawQuery(
      'SELECT COUNT(*) as total FROM daftar_resep WHERE isFavorite = 1',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  static Future<void> simpanData(ResepModel data) async {
    final db = await initDB();
    await db.insert(
      'daftar_resep',
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<ResepModel>> getAllData() async {
    final db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query('daftar_resep');
    return List.generate(maps.length, (i) => ResepModel.fromMap(maps[i]));
  }

  static Future<int> getTotalResep() async {
    final db = await initDB();
    final result = await db.rawQuery('SELECT COUNT(*) FROM daftar_resep');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  static Future<void> updateData(ResepModel data) async {
    final db = await initDB();
    final result = await db.update(
      'daftar_resep',
      data.toMap(),
      where: 'id = ?',
      whereArgs: [data.id],
    );

    print('Jumlah row yang diperbarui: $result');
  }

  static Future<void> deleteData(int id) async {
    final db = await initDB();
    await db.delete('daftar_resep', where: 'id = ?', whereArgs: [id]);
  }
}
