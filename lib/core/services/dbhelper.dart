import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:toko_online/features/cart/models/cart.dart';

class DBHelper {
  static Database? _database;

  /// ================= DATABASE =================
  Future<Database?> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDatabase();
    return _database!;
  }

  /// ================= INIT DATABASE =================
  initDatabase() async {
    if (io.Platform.isWindows || io.Platform.isLinux || io.Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    io.Directory directory = await getApplicationDocumentsDirectory();

    String path = join(directory.path, 'cart.db');

    var db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );

    return db;
  }

  /// ================= CREATE TABLE =================
  _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE cart(
        id INTEGER PRIMARY KEY,
        barang_id TEXT,
        nama_barang TEXT,
        harga INTEGER,
        quantity INTEGER,
        image TEXT
      )
      ''',
    );
  }

  /// ================= INSERT CART =================
  Future<Cart> insert(Cart cart) async {
    var dbClient = await database;

    await dbClient!.insert(
      'cart',
      cart.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return cart;
  }

  /// ================= GET CART =================
  Future<List<Cart>> getCartList() async {
    var dbClient = await database;

    final List<Map<String, Object?>> queryResult =
        await dbClient!.query('cart');

    return queryResult
        .map((e) => Cart.fromMap(e))
        .toList();
  }

  /// ================= DELETE CART =================
  Future deleteCartItem(int id) async {
    var dbClient = await database;

    return await dbClient!.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// ================= UPDATE QUANTITY =================
  Future updateQuantity(id, qty) async {
    var dbClient = await database;

    return await dbClient!.update(
      'cart',
      {
        "quantity": qty,
      },
      where: "id = ?",
      whereArgs: [id],
    );
  }

  /// ================= DETAIL CART =================
  Future getCartListDetail(id) async {
    var dbClient = await database;

    final queryResult = await dbClient!.query(
      'cart',
      where: 'id = ?',
      whereArgs: [id],
    );

    return queryResult
        .map((e) => Cart.fromMap(e))
        .toList();
  }
}