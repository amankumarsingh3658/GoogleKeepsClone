import 'dart:async';
import 'dart:core';
import 'dart:ui';
import 'package:googlekeepnotesclone/Services/Mynotemodel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class NotesDatabase {
  static NotesDatabase instance = NotesDatabase._init();
  static Database? _database;
  NotesDatabase._init();

  Future<Database?> getDatabase() async {
    if (_database != null) {
      return _database;
    }
    _database = await initializeDB('Notes.db');
    return _database;
  }

  Future<Database> initializeDB(String filepath) async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, filepath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, version) async {
    final idType = "Integer Primary Key AutoIncrement";
    final boolType = "Boolean not null";
    final textType = "Text not null";
    await db.execute('''
    Create table ${NotesImpNames.Tablename}(
    ${NotesImpNames.id} ${idType}, 
    ${NotesImpNames.pin} ${boolType},
    ${NotesImpNames.title} ${textType},
    ${NotesImpNames.content} ${textType},
    ${NotesImpNames.createdtime} ${textType}
    )
    ''');
  }

  Future<Note?> createEntry(Note note) async {
    final db = await instance.getDatabase();
    final newNoteid = await db!
        .insert(NotesImpNames.Tablename, note.toJson()); //this returns int.
    return note.copy(id: newNoteid);
  }

  Future<List<Note>> readNotes() async {
    final db = await instance.getDatabase();
    final orderby = '${NotesImpNames.createdtime} desc';
    final query_result =
        await db!.query(NotesImpNames.Tablename, orderBy: orderby);
    print(query_result);
    return query_result.map((json) => Note.fromJson(json)).toList();
  }

  Future readoneNote(int id) async {
    final db = await instance.getDatabase();
    final query_result = await db!.query(NotesImpNames.Tablename,
        columns: NotesImpNames.values,
        where: "${NotesImpNames.id} = ?",
        whereArgs: [id]);
    if (query_result.isNotEmpty) {
      return Note.fromJson(query_result.first);
    } else {
      return null;
    }
  }

  Future updateNote(Note note) async {
    final db = await instance.getDatabase();
    db!.update(NotesImpNames.Tablename, note.toJson(),
        where: '${NotesImpNames.id} = ?', whereArgs: [note.id]);
  }

  Future deleteNote(Note note) async {
    final db = await instance.getDatabase();
    db!.delete(NotesImpNames.Tablename,
        where: '${NotesImpNames.id} = ?', whereArgs: [note.id]);
  }

  Future closeDB() async {
    final db = await instance.getDatabase();
    db!.close();
  }

  Future deletedb(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);
    databaseFactory.deleteDatabase(path);
  }

  // Future<List<int>> getNoteString(String query) async {
  //   final db = await instance.getDatabase();
  //   final result = await db!.query(NotesImpNames.Tablename);
  //   List<int> idList = [];
  //   result.forEach((element) {
  //     if (element["title"]
  //             .toString()
  //             .toLowerCase()
  //             .contains(query.toLowerCase()) ||
  //         element["content"]
  //             .toString()
  //             .toLowerCase()
  //             .contains(query.toLowerCase())) {
  //       idList.add(element["id"] as int);
  //     }
  //   });
  //   return idList;
  // }

  Future<List<int>> getAllNotesId(String query) async {
    final db = await instance.getDatabase();
    final getAllNotesData = await db!.query(NotesImpNames.Tablename);
    List<int> idList = [];
    getAllNotesData.forEach((element) {
      if (element['title']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          element['content']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase())) {
        return idList.add(element['id'] as int);
      } else {
        return null;
      }
    });
    // print(idList);
    return idList;
  }

  // Future<List<int>> getallIds() async {
  //   final db = await instance.getDatabase();
  //   final allrecords = await db!.query(NotesImpNames.Tablename);
  //   List<int> allid = [];
  //   allrecords.forEach((element) {
  //     allid.add(element["id"] as int);
  //   });
  //   return allid;
  // }
}
