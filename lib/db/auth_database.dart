import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AuthDatabase {
  static final AuthDatabase instance = AuthDatabase._init();
  static Database? _database;

  AuthDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('auth.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final docsDir = await getApplicationDocumentsDirectory();
    final path = join(docsDir.path, fileName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  // Hash password using SHA256
  static String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  // Login user and return user ID
  Future<int?> loginUser(String username, String password) async {
    try {
      final db = await instance.database;
      final hashedPassword = hashPassword(password);
      final result = await db.query(
        'users',
        where: 'username = ? AND password = ?',
        whereArgs: [username, hashedPassword],
        limit: 1,
      );
      if (result.isNotEmpty) {
        return result.first['id'] as int?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Register user and return user ID
  Future<int?> registerUser(String username, String password) async {
    try {
      final db = await instance.database;
      final hashedPassword = hashPassword(password);
      final id = await db.insert('users', {
        'username': username,
        'password': hashedPassword,
        'createdAt': DateTime.now().toIso8601String(),
      });
      return id;
    } catch (e) {
      // Username already exists or other error
      return null;
    }
  }

  // Check if username exists
  Future<bool> usernameExists(String username) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
