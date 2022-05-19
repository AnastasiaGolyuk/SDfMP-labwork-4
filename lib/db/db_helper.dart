import 'dart:async';
import 'dart:io';

import 'package:planner/models/event.dart';
import 'package:planner/models/note.dart';
import 'package:planner/models/uploaded_image.dart';
import 'package:planner/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'labwork__4__planner.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
          id INTEGER PRIMARY KEY,
          username TEXT,
          email TEXT,
          passwordHash TEXT,
          isAuthorized INTEGER
      )
      ''');

    await db.execute('''
      CREATE TABLE uploaded_image(
          id INTEGER PRIMARY KEY,
          idNote INTEGER,
          bytes BLOB
      )
      ''');

    await db.execute('''
      CREATE TABLE notes(
          id INTEGER PRIMARY KEY,
          idUser INTEGER,
          title TEXT,
          description TEXT
      )
      ''');

    await db.execute('''
      CREATE TABLE events(
          id INTEGER PRIMARY KEY,
          idUser INTEGER,
          title TEXT,
          start TEXT,
          end TEXT,
          isAllDay INTEGER,
          repeat TEXT
      )
      ''');
  }

  Future<List<User>> getUsers() async {
    Database db = await instance.database;
    var results = await db.query('users');
    List<User> usersList = results.isNotEmpty
        ? results.map((c) => User.fromJson(c)).toList()
        : [];
    return usersList;
  }

  Future<List<UploadedImage>> getImages() async {
    Database db = await instance.database;
    var results = await db.query('uploaded_image');
    List<UploadedImage> imagesList = results.isNotEmpty
        ? results.map((c) => UploadedImage.fromJson(c)).toList()
        : [];
    return imagesList;
  }

  Future<List<Event>> getEvents() async {
    Database db = await instance.database;
    var results = await db.query('events');
    List<Event> eventsList = results.isNotEmpty
        ? results.map((c) => Event.fromJson(c)).toList()
        : [];
    return eventsList;
  }

  Future<int> getEventsCount() async {
    Database db = await instance.database;
    var results = await db.query('events');
    List<Event> eventsList = results.isNotEmpty
        ? results.map((c) => Event.fromJson(c)).toList()
        : [];
    return eventsList.length;
  }

  Future<UploadedImage?> getImage(int idNote) async {
    Database db = await instance.database;
    var results = await db.query('uploaded_image',where: 'idNote = ?', whereArgs: [idNote]);
    List<UploadedImage> imagesList = results.isNotEmpty
        ? results.map((c) => UploadedImage.fromJson(c)).toList()
        : [];
    if (imagesList.isEmpty){
      return null;
    }
    return imagesList.first;
  }

  Future<int> getImagesCount() async {
    Database db = await instance.database;
    var results = await db.query('uploaded_image');
    List<UploadedImage> imagesList = results.isNotEmpty
        ? results.map((c) => UploadedImage.fromJson(c)).toList()
        : [];
    return imagesList.length;
  }

  Future<int> addImage(UploadedImage image) async {
    Database db = await instance.database;
    return await db.insert('uploaded_image', image.toJson());
  }

  Future<int> deleteImage(int idNote) async {
    Database db = await instance.database;
    return await db.delete('uploaded_image', where: "idNote = ?", whereArgs: [idNote]);
  }

  Future<int> addEvent(Event event) async {
    Database db = await instance.database;
    return await db.insert('events', event.toJson());
  }

  Future<int> deleteEvent(int id) async {
    Database db = await instance.database;
    return await db.delete('events', where: "id = ?", whereArgs: [id]);
  }

  Future<int> updateEvent(Event event) async {
    Database db = await instance.database;
    return await db.update('events', event.toJson(), where: 'id = ?', whereArgs: [event.id], );
  }

  Future<Note> getNote(int id) async {
    Database db = await instance.database;
    var results = await db.query('notes',where: 'id = ?', whereArgs: [id]);
    List<Note> notesList = results.isNotEmpty
        ? results.map((c) => Note.fromJson(c)).toList()
        : [];
    return notesList.first;
  }



  Future<List<Note>> getNotes(int idUser) async {
    Database db = await instance.database;
    var results = await db.query('notes',where: 'idUser = ?', whereArgs: [idUser]);
    List<Note> notesList = results.isNotEmpty
        ? results.map((c) => Note.fromJson(c)).toList()
        : [];
    return notesList;
  }

  Future<int> getNotesCount() async {
    Database db = await instance.database;
    var results = await db.query('notes');
    List<Note> notesList = results.isNotEmpty
        ? results.map((c) => Note.fromJson(c)).toList()
        : [];
    return notesList.length;
  }

  Future<int> addNote(Note note) async {
    Database db = await instance.database;
    return await db.insert('notes', note.toJson());
  }

  Future<int> deleteNote(int id) async {
    Database db = await instance.database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }


  Future<User?> findAuthUser() async {
    var results = await getUsers();
    User? user;
    for (var element in results) {
      print("id ${element.id} ${element.username}  auth ${element.isAuthorized}");
      if (element.isAuthorized==1){
        user=element;
        return user;
      }
    }
    return null;
  }

  Future<int> updateUser(User user) async {
    Database db = await instance.database;
    return await db.update('users', user.toJson(), where: 'id = ?', whereArgs: [user.id]);
  }


  Future<int> getUsersCount() async {
    var results = await getUsers();
    return results.length;
  }

  Future<int> addUser(User user) async {
    Database db = await instance.database;
    return await db.insert('users', user.toJson());
  }

  Future<User?> findUser(String email) async {
    var results = await getUsers();
    User? user;
    for (var element in results) {
      if (element.email==email){
        user=element;
        return user;
      }
    }
    return null;
  }
}
