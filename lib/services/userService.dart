import 'package:mau_makan/models/foodPlace.dart';
import 'package:mau_makan/models/user.dart';
import 'package:mau_makan/helpers/dbHelper.dart';
import 'package:sqflite/sqflite.dart';

class UserService {
  final DbHelper dbHelper = DbHelper();

  Future<int> insertUser(UserModel user) async {
    final db = await dbHelper.database;
    return await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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

  // Food Places CRUD operations
  Future<int> insertFoodPlace(FoodPlaceModel foodPlace) async {
    final db = await dbHelper.database;
    return await db.insert(
      'food_places',
      foodPlace.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<FoodPlaceModel>> getAllFoodPlaces() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('food_places');
    return List.generate(maps.length, (i) {
      return FoodPlaceModel.fromMap(maps[i]);
    });
  }

  Future<FoodPlaceModel?> getFoodPlace(int id) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'food_places',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return FoodPlaceModel.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateFoodPlace(FoodPlaceModel foodPlace) async {
    final db = await dbHelper.database;
    return await db.update(
      'food_places',
      foodPlace.toMap(),
      where: 'id = ?',
      whereArgs: [foodPlace.id],
    );
  }

  Future<int> deleteFoodPlace(int id) async {
    final db = await dbHelper.database;
    return await db.delete('food_places', where: 'id = ?', whereArgs: [id]);
  }
}
