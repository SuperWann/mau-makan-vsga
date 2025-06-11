import 'package:mau_makan/models/user.dart';
import 'package:mau_makan/helpers/dbHelper.dart';
import 'package:sqflite/sqflite.dart';

class UserService {
  
  final DbHelper dbHelper = DbHelper();

  Future<int> insertUser(UserModel user) async {
    final db = await dbHelper.database;
    return await db.insert('users', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<UserModel?> getUserByUsername(String username) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  Future<List<UserModel>> getAllUsers() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return UserModel.fromMap(maps[i]);
    });
  }
}