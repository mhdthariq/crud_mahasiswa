import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'mahasiswa.dart';
import 'user.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE mahasiswa (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT,
        nim TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        password TEXT
      )
    ''');
  }

  // Insert User (Registration)
  Future<int> registerUser(User user) async {
    final db = await instance.database;
    return await db.insert('users', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Check User Login
  Future<User?> loginUser(String username, String password) async {
    final db = await instance.database;
    final result = await db.query('users',
        where: 'username = ? AND password = ?', whereArgs: [username, password]);
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  // Insert Student
  Future<int> insertMahasiswa(Mahasiswa mahasiswa) async {
    final db = await instance.database;
    return await db.insert('mahasiswa', mahasiswa.toMap());
  }

  // Get All Students
  Future<List<Mahasiswa>> getAllMahasiswa() async {
    final db = await instance.database;
    final result = await db.query('mahasiswa');
    return result.map((e) => Mahasiswa.fromMap(e)).toList();
  }

  // Update Student
  Future<int> updateMahasiswa(Mahasiswa mahasiswa) async {
    final db = await instance.database;
    return await db.update('mahasiswa', mahasiswa.toMap(), where: 'id = ?', whereArgs: [mahasiswa.id]);
  }

  // Delete Student
  Future<int> deleteMahasiswa(int id) async {
    final db = await instance.database;
    return await db.delete('mahasiswa', where: 'id = ?', whereArgs: [id]);
  }
}