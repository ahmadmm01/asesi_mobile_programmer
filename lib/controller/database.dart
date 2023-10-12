import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/book_model.dart';

/// Kelas `DatabaseHelper` adalah utilitas untuk mengelola database buku.
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  /// Fungsi getter `db` digunakan untuk mendapatkan koneksi ke database.
  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  DatabaseHelper.internal();

  /// Fungsi `initDb` digunakan untuk inisialisasi database.
  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'book_database.db');

    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  /// Fungsi `_onCreate` digunakan untuk membuat tabel `books` saat database dibuat.
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

    // Menambahkan data dummy saat database dibuat
    List<Book> getDummyBooks() {
      return [
        Book(
          title: "The Great Gatsby",
          author: "F. Scott Fitzgerald",
          publisher: "Scribner",
          publishYear: 1925,
          isbn: "ISBN-9780743273565",
          availability: 1,
          review: "A classic novel of the Jazz Age.",
          sinopsis:
              "The story of the fabulously wealthy Jay Gatsby and his love for the beautiful Daisy Buchanan.",
        ),
        Book(
          title: "To Kill a Mockingbird",
          author: "Harper Lee",
          publisher: "J.B. Lippincott & Co.",
          publishYear: 1960,
          isbn: "ISBN-9780061120084",
          availability: 0,
          review: "One of the greatest novels of the 20th century.",
          sinopsis:
              "The story of a young girl's experience with racial injustice in the American South.",
        ),
        Book(
          title: "1984",
          author: "George Orwell",
          publisher: "Secker & Warburg",
          publishYear: 1949,
          isbn: "ISBN-9780451524935",
          availability: 1,
          review: "A dystopian masterpiece.",
          sinopsis:
              "A novel set in a totalitarian society where individuality and freedom are suppressed.",
        ),
        Book(
          title: "Pride and Prejudice",
          author: "Jane Austen",
          publisher: "T. Egerton, Whitehall",
          publishYear: 1813,
          isbn: "ISBN-9780141439518",
          availability: 1,
          review: "A classic romance novel.",
          sinopsis:
              "The story of the strong-willed Elizabeth Bennet and her tumultuous relationship with the enigmatic Mr. Darcy.",
        ),
        Book(
          title: "The Hobbit",
          author: "J.R.R. Tolkien",
          publisher: "George Allen & Unwin",
          publishYear: 1937,
          isbn: "ISBN-9780547928227",
          availability: 1,
          review: "A fantasy adventure novel.",
          sinopsis:
              "The journey of Bilbo Baggins as he joins a group of dwarves on a quest to reclaim their homeland from a dragon.",
        ),
        Book(
          title: "Moby-Dick",
          author: "Herman Melville",
          publisher: "Richard Bentley",
          publishYear: 1851,
          isbn: "ISBN-9780142000083",
          availability: 0,
          review: "A classic novel about obsession.",
          sinopsis:
              "The story of Captain Ahab's relentless pursuit of the white whale, Moby-Dick.",
        ),
        Book(
          title: "The Catcher in the Rye",
          author: "J.D. Salinger",
          publisher: "Little, Brown and Company",
          publishYear: 1951,
          isbn: "ISBN-9780316769174",
          availability: 1,
          review: "A coming-of-age novel.",
          sinopsis:
              "The story of Holden Caulfield's experiences in New York City.",
        ),
        Book(
          title: "The Lord of the Rings",
          author: "J.R.R. Tolkien",
          publisher: "George Allen & Unwin",
          publishYear: 1954,
          isbn: "ISBN-9780618640157",
          availability: 1,
          review: "A classic epic fantasy trilogy.",
          sinopsis:
              "The epic tale of Frodo Baggins and his quest to destroy the One Ring.",
        ),
        Book(
          title: "Brave New World",
          author: "Aldous Huxley",
          publisher: "Chatto & Windus",
          publishYear: 1932,
          isbn: "ISBN-9780060850524",
          availability: 0,
          review: "A dystopian novel.",
          sinopsis:
              "A futuristic society that has achieved apparent harmony at the expense of individuality.",
        ),
        Book(
          title: "War and Peace",
          author: "Leo Tolstoy",
          publisher: "The Russian Messenger",
          publishYear: 1869,
          isbn: "ISBN-9780143039990",
          availability: 1,
          review: "A classic novel of historical fiction.",
          sinopsis:
              "The story of five aristocratic families during the Napoleonic era in Russia.",
        ),
      ];
    }

    // Menggunakan batch untuk menambahkan data dummy ke database
    List<Book> dummyBooks = getDummyBooks();
    Batch batch = db.batch();
    for (Book book in dummyBooks) {
      batch.insert('books', book.toMap());
    }
    await batch.commit();
  }

  /// Fungsi `getBooks` digunakan untuk mengambil daftar buku dari database.
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

  /// Fungsi `getBookById` digunakan untuk mengambil detail buku berdasarkan ID.
  Future<Book?> getBookById(int id) async {
    var dbClient = await db;
    List<Map> maps =
        await dbClient.query('books', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Book.fromMap(maps.first.cast<String, dynamic>());
    }
    return null;
  }

  /// Fungsi `searchBooks` digunakan untuk melakukan pencarian buku berdasarkan judul atau penulis.
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
