import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../../model/mini_gallery_model.dart';

const String miniTable = 'mini_gallery';
const String miniTableColumId = 'id';
const String miniTableColumImagePath = 'imagePath';
const String miniTableColumDatetime = 'dateTime';

class DbHelper {
  DbHelper._privateConstructor();
  static final DbHelper instance = DbHelper._privateConstructor();

  Database? _database;

  Future<Database> checkDatabase() async {
    if (_database != null) return _database!;
    return await openDb();
  }

  final String createTableQuery = '''
    CREATE TABLE $miniTable(
      $miniTableColumId INTEGER PRIMARY KEY AUTOINCREMENT,
      $miniTableColumImagePath TEXT,
      $miniTableColumDatetime TEXT
    )
  ''';

  Future<Database> openDb() async {
    Directory rootDir = await getApplicationDocumentsDirectory();
    print(' roothPath : ${rootDir.path}');
    final dbPath = path.join(rootDir.path, 'mini_gallery.db');
    return await openDatabase(dbPath, version: 1, onCreate: (db, version) async {
      await db.execute(createTableQuery);
      // await deleteDatabase(dbPath);
    });

  }

  Future<int> insertData(MiniGalleryModel node) async {
    final db = await checkDatabase();
    return await db.insert(miniTable, node.toMap());
  }

  Future<List<MiniGalleryModel>> getAllData() async {
    final db = await checkDatabase();
    final dataList = await db.query(miniTable,);
    return List.generate(dataList.length, (index) => MiniGalleryModel.fromMap(dataList[index]));
  }
  Future<int> deleteTodo (int id)async{
    final db = await checkDatabase();
    return await db.delete(miniTable,where:'$miniTableColumId = ?',whereArgs: [id]);
  }
  Future<int> upDate (int id)async{
    final db = await checkDatabase();
    return await db.update(miniTable,{},where:'$miniTableColumId = ?',whereArgs: [id]);
  }
}
