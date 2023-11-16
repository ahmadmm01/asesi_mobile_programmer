// test/view/book_detail_page_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:asesi_mobile_programmer/model/book_model.dart';
import 'package:asesi_mobile_programmer/view/book_detail.dart';

void main() {
  testWidgets('Test BookDetailPage widget', (WidgetTester tester) async {
    // Create a Book object for testing
    Book testBook = Book(
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

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: BookDetailPage(book: testBook),
      ),
    );

    // Verify that the title is rendered on the screen
    expect(find.text('Detail Buku'), findsOneWidget);

    // Verify that book details are displayed correctly
    expect(find.text('Test Book'), findsOneWidget);
    expect(find.text('Penulis: Test Author'), findsOneWidget);
    expect(find.text('Penerbit: Test Publisher'), findsOneWidget);
    expect(find.text('Tahun Terbit: 2022'), findsOneWidget);
    expect(find.text('ISBN: ISBN-1234567890'), findsOneWidget);
    expect(find.text('Ketersediaan: 1'), findsOneWidget);
    expect(find.text('Review: Test Review'), findsOneWidget);
    expect(find.text('Sinopsis:'), findsOneWidget);
    expect(find.text('Test Sinopsis'), findsOneWidget);
  });
}
