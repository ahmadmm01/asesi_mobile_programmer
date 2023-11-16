import 'package:flutter_test/flutter_test.dart';
import 'package:asesi_mobile_programmer/model/book_model.dart';

void main() {
  test('Test converting Book to Map', () {
    Book book = Book(
      id: 1,
      title: 'Test Book',
      author: 'Test Author',
      publisher: 'Test Publisher',
      publishYear: 2022,
      isbn: 'ISBN-1234567890',
      availability: 1,
      review: 'Test Review',
      sinopsis: 'Test Sinopsis',
    );

    Map<String, dynamic> map = book.toMap();

    expect(map['id'], equals(1));
    expect(map['title'], equals('Test Book'));
    expect(map['author'], equals('Test Author'));
    expect(map['publisher'], equals('Test Publisher'));
    expect(map['publishYear'], equals(2022));
    expect(map['isbn'], equals('ISBN-1234567890'));
    expect(map['availability'], equals(1));
    expect(map['review'], equals('Test Review'));
    expect(map['sinopsis'], equals('Test Sinopsis'));
  });

  test('Test creating Book from Map', () {
    Map<String, dynamic> map = {
      'id': 2,
      'title': 'Another Test Book',
      'author': 'Another Test Author',
      'publisher': 'Another Test Publisher',
      'publishYear': 2023,
      'isbn': 'ISBN-0987654321',
      'availability': 0,
      'review': 'Another Test Review',
      'sinopsis': 'Another Test Sinopsis',
    };

    Book book = Book.fromMap(map);

    expect(book.id, equals(2));
    expect(book.title, equals('Another Test Book'));
    expect(book.author, equals('Another Test Author'));
    expect(book.publisher, equals('Another Test Publisher'));
    expect(book.publishYear, equals(2023));
    expect(book.isbn, equals('ISBN-0987654321'));
    expect(book.availability, equals(0));
    expect(book.review, equals('Another Test Review'));
    expect(book.sinopsis, equals('Another Test Sinopsis'));
  });
}
