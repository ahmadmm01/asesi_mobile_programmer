import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/book_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  DatabaseHelper.internal();

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'book_database.db');

    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE books (
        id INTEGER PRIMARY KEY,
        title TEXT,
        author TEXT,
        publisher TEXT,
        publishYear INTEGER,
        isbn TEXT,
        availability INTEGER,
        review TEXT,
        sinopsis TEXT
      )
    ''');

    List<Book> getDummyBooks() {
      return [
        Book(
          title: "Book 1",
          author: "Author 1",
          publisher: "Publisher A",
          publishYear: 2021,
          isbn: "ISBN-123456789",
          availability: 1,
          review: "Review 1",
          sinopsis: "Sinopsis 1",
        ),
        Book(
          title: "Book 2",
          author: "Author 2",
          publisher: "Publisher B",
          publishYear: 2022,
          isbn: "ISBN-987654321",
          availability: 0,
          review: "Review 2",
          sinopsis: "Sinopsis 2",
        ),
      ];
    }

    // Tambahkan kode ini untuk memasukkan data dummy saat database dibuat
    List<Book> dummyBooks = getDummyBooks();
    Batch batch = db.batch();
    for (Book book in dummyBooks) {
      batch.insert('books', book.toMap());
    }
    await batch.commit();
  }

  // Fungsi untuk mengambil daftar buku dari database
  Future<List<Book>> getBooks() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('books');
    List<Book> books = [];
    if (maps.isNotEmpty) {
      for (Map map in maps) {
        books.add(Book.fromMap(map.cast<String, dynamic>()));
      }
    }
    print('Fetched ${books.length} books from the database.'); // Add this line

    return books;
  }

  // Fungsi untuk mengambil detail buku berdasarkan ID
  Future<Book?> getBookById(int id) async {
    var dbClient = await db;
    List<Map> maps =
        await dbClient.query('books', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Book.fromMap(maps.first.cast<String, dynamic>());
    }
    return null;
  }

  // Fungsi untuk melakukan pencarian buku berdasarkan judul atau penulis
  Future<List<Book>> searchBooks(String searchTerm) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('books',
        where: 'title LIKE ? OR author LIKE ?',
        whereArgs: ['%$searchTerm%', '%$searchTerm%']);
    List<Book> books = [];
    if (maps.isNotEmpty) {
      for (Map map in maps) {
        books.add(Book.fromMap(map.cast<String, dynamic>()));
      }
    }
    return books;
  }
}
