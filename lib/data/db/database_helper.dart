import 'package:restaurant_app/data/model/restaurant_detail_model.dart'
    as restaurant_detail;
import 'package:restaurant_app/data/model/restaurant_list_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tblBookmark = 'restaurant_bookmarks';

  /// initialize database + create table
  Future<Database> _initializeDB() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/restaurant_app.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tblBookmark (
            id TEXT PRIMARY KEY,
            name TEXT,
            description TEXT,
            pictureId TEXT,
            city TEXT,
            rating REAL
          )
        ''');
      },
      version: 1,
    );
    return db;
  }

  Future<Database?> get database async {
    _database ??= await _initializeDB();

    return _database;
  }

  Future<void> insertRestaurantBookmark(
      restaurant_detail.Restaurant restaurantDetail) async {
    final db = await database;
    Restaurant restaurant = Restaurant(
        id: restaurantDetail.id,
        name: restaurantDetail.name,
        description: restaurantDetail.description,
        pictureId: restaurantDetail.pictureId,
        city: restaurantDetail.city,
        rating: restaurantDetail.rating);
    await db?.insert(_tblBookmark, restaurant.toJson());
  }

  Future<List<Restaurant>> getRestaurantBookmarks() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tblBookmark);
    return results.map((res) => Restaurant.fromJson(res)).toList();
  }

  Future<Map> getRestaurantBookmarkById(String id) async {
    final db = await database;

    List<Map<String, dynamic>>? results = await db!.query(
      _tblBookmark,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    }

    return {};
  }

  Future<void> removeBookmark(String id) async {
    final db = await database;

    await db?.delete(
      _tblBookmark,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
