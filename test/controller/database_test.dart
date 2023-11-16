import 'package:flutter_test/flutter_test.dart';
import 'package:asesi_mobile_programmer/controller/database.dart';
import 'package:asesi_mobile_programmer/model/book_model.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  late DatabaseHelper dbHelper;

  setUp(() {
    dbHelper = DatabaseHelper();
  });

  test('Test initialization of database', () async {
    Database db = await dbHelper.db;
    expect(db.isOpen, equals(true));
  });

  test('Test fetching books from the database', () async {
    List<Book> books = await dbHelper.getBooks();
    expect(books.length, greaterThan(0));
  });

  test('Test fetching a book by ID from the database', () async {
    int bookId = 1; // assuming there is a book with ID 1 in your dummy data
    Book? book = await dbHelper.getBookById(bookId);
    expect(book, isNotNull);
    expect(book!.id, equals(bookId));
  });

  test('Test searching books in the database', () async {
    String searchTerm = 'Gatsby'; // assuming there is a book with 'Gatsby' in the title or author
    List<Book> books = await dbHelper.searchBooks(searchTerm);
    expect(books.length, greaterThan(0));
  });
}
