import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseConnection {
  Future<Database> setDatabase() async {
    // untuk menyimpana database pada path local
    var dir = await getApplicationDocumentsDirectory();
    var path = join(dir.path, 'db_crud');
    // cara membuat database
    var database =
        await openDatabase(path, version: 1, onCreate: _createDatabase);
    return database;
  }

  // koneksi dan create database
  Future<void> _createDatabase(Database database, int version) async {
    String sql =
        "CREATE TABLE users (id INTEGER PRIMARY KEY,name TEXT,contact TEXT,description TEXT);";
    await database.execute(sql);
  }
}
