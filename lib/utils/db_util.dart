import 'package:myeasylist/utils/util.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DbUtil {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, DbConfig.dbName + DbConfig.dbExtension),
      onCreate: (db, version) {
        return db.execute('CREATE TABLE  ' + DbConfig.dbName + ' (id INTEGER PRIMARY KEY, item TEXT, checked INTEGER)');
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DbUtil.database();
    await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<void> update(String table, Map<String, Object> data) async {
    final db = await DbUtil.database();
    await db.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [data['id']],
      conflictAlgorithm: sql.ConflictAlgorithm.rollback,
    );
  }

  static Future<void> remove(String table, int id) async {
    final db = await DbUtil.database();
    await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DbUtil.database();
    return db.query(table);
  }
}
