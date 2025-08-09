import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/property.dart';
import '../models/inspection.dart';

class DBService {
  static final DBService _instance = DBService._internal();
  factory DBService() => _instance;
  DBService._internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'leaseproof.db');

    return openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE properties (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          address TEXT
        )
      ''');

      await db.execute('''
        CREATE TABLE inspections (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          propertyId INTEGER,
          tenantName TEXT,
          type TEXT,
          createdAt TEXT
        )
      ''');
    });
  }

  Future<int> insertProperty(Property p) async {
    final database = await db;
    return await database.insert('properties', p.toMap());
  }

  Future<List<Property>> getProperties() async {
    final database = await db;
    final res = await database.query('properties');
    return res.map((r) => Property.fromMap(r)).toList();
  }

  Future<int> insertInspection(Inspection i) async {
    final database = await db;
    return await database.insert('inspections', i.toMap());
  }

  Future<List<Inspection>> getInspectionsForProperty(int propertyId) async {
    final database = await db;
    final res = await database.query('inspections', where: 'propertyId = ?', whereArgs: [propertyId]);
    return res.map((r) => Inspection.fromMap(r)).toList();
  }
}
