import 'dart:io';

import 'package:movie_list/models/movie_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class dataBaseHelper {
  static final dataBaseHelper instance = dataBaseHelper._instance();
  static Database _db;

  dataBaseHelper._instance();

  String movieTables = 'movie_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDirector = 'director';

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'movie_list.db';
    final movieListDb =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return movieListDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $movieTables($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colTitle TEXT,$colDirector TEXT)',
    );
  }

  Future<List<Map<String, dynamic>>> getMovieMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(movieTables);
    return result;
  }

  Future<List<movie>> getMovieList() async {
    final List<Map<String, dynamic>> movieMapList =
        (await getMovieList()).cast<Map<String, dynamic>>();
    final List<movie> movieList = [];
    movieMapList.forEach((movieMap) {
      movieList.add(movie.fromMap(movieMap));
    });
    return movieList;
  }

  Future<int> insertMovie(movie Movie) async {
    Database db = await this.db;
    final int result = await db.insert(movieTables, Movie.toMap());
    return result;
  }

  Future<int> updateMovie(movie Movie) async {
    Database db = await this.db;
    final int result = await db.update(
      movieTables,
      Movie.toMap(),
      where: '$colId = ?',
      whereArgs: [Movie.id],
    );
    return result;
  }

  Future<int> deleteMovie(int id) async {
    Database db = await this.db;
    final int result = await db.delete(
      movieTables,
      where: '$colId = ?',
      whereArgs: [id],
    );
    return result;
  }
}
