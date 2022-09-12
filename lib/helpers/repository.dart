// repo untuk service users
import 'package:sqflite/sqflite.dart';
import 'package:crud/helpers/database_connection.dart';

class Repository {
  late DatabaseConnection _databaseConnection;
  Repository() {
    _databaseConnection = DatabaseConnection();
  }

  // koneksi database ke repo yang kita miliki untuk melakuka query SQL
  static Database? _database;
  Future<Database?> get database async {
    // cek koneksi database
    if (_database != null) {
      return _database;
    } else {
      _database = await _databaseConnection.setDatabase();
      return _database;
    }
  }

  // query select untuk sevices menggunakan ORM
  // insert, update, delete, query
  // get all data
  readData(table) async {
    var connection = await database;
    return await connection?.query(table);
  }

  // insert data
  insertData(table, data) async {
    var connection = await database;
    return await connection?.insert(table, data);
  }

  // update user by id
  updateData(table, data) async {
    var connection = await database;
    return await connection
        ?.update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

  // delete data
  deleteDatabyId(table, itemId) async {
    var connection = await database;
    return await connection?.rawDelete("DELETE FROM $table WHERE id=$itemId");
  }

  // get detail user dengan id
  readDataById(table, itemId) async {
    var connection = await database;
    return await connection?.query(table, where: 'id=?', whereArgs: [itemId]);
  }
}
