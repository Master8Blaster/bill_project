import 'dart:io';

import 'package:bill_project/Database/tables/CartDbModel.dart';
import 'package:bill_project/screens/home/models/ProductModel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "dublincoach.db";
  static final _newDbVersion = 11;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _newDbVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future _onCreate(Database db, int version) async {
    var batch = db.batch();
    await db.execute(CartDbModel.createTable);
    batch.commit();
  }

  Future _onUpgrade(Database db, int oldVersion, int newversion) async {
    var batch = db.batch();
    if (oldVersion != _newDbVersion) {
      await db.execute('drop table if exists ${CartDbModel.tableName}');
      _onCreate(db, _newDbVersion);
    }
    await batch.commit();
  }

  Future<List<ProductModel>> getCartProducts() async {
    Database db = await instance.database;
    String query = "SELECT * FROM ${CartDbModel.tableName}";
    List<Map<String, dynamic>> maps = await db.rawQuery(query);
    List<ProductModel> listProductModel = [];
    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        listProductModel.add(ProductModel.fromJson(maps[i]));
      }
    }
    return listProductModel;
  }

  Future<int> addToCart(ProductModel model) async {
    Database db = await instance.database;
    return await db.insert(CartDbModel.tableName, model.toJson());
  }

  Future<bool> isProductExistInCart(String productKey) async {
    Database db = await instance.database;
    String query =
        "SELECT * FROM ${CartDbModel.tableName} WHERE ${CartDbModel.productKey}='$productKey'";
    final List<Map<String, dynamic>> result = await db.rawQuery(query);
    if (result.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<int> updateProduct(ProductModel model) async {
    Database db = await instance.database;
    String query =
        "UPDATE ${CartDbModel.tableName} SET ${CartDbModel.productName}='${model.name}',${CartDbModel.price}=${model.price},${CartDbModel.quantity}=${model.quantity.value},${CartDbModel.pQuantity}=${model.pQuantity},${CartDbModel.imageName}='${model.imageName}',${CartDbModel.imageUrl}='${model.imageUrl}' WHERE ${CartDbModel.productKey}='${model.productKey}'";
    return await db.rawUpdate(query);
  }

  Future<int> deleteProduct(String key) async {
    Database db = await instance.database;
    return await db.delete(CartDbModel.tableName,
        where: "${CartDbModel.productKey}='$key'");
  }

  Future<int> deleteAllCartProducts() async {
    Database db = await instance.database;
    return await db.delete(CartDbModel.tableName);
  }
}
