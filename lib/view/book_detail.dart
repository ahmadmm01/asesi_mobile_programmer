import 'package:flutter/material.dart';
import '../model/book_model.dart';

/// Halaman detail buku yang menampilkan informasi lengkap tentang sebuah buku.
///
/// Stateles widget ini digunakan untuk membuat tampilan halaman detail buku
/// yang menampilkan judul, penulis, penerbit, tahun terbit, ISBN, status ketersediaan,
/// review, dan sinopsis sebuah buku.
class BookDetailPage extends StatelessWidget {
  final Book book;

  const BookDetailPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Buku'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              book.title ?? '',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Penulis: ${book.author ?? ''}', style: const TextStyle(fontSize: 18)),
            Text('Penerbit: ${book.publisher ?? ''}', style: const TextStyle(fontSize: 18)),
            Text('Tahun Terbit: ${book.publishYear ?? ''}', style: const TextStyle(fontSize: 18)),
            Text('ISBN: ${book.isbn ?? ''}', style: const TextStyle(fontSize: 18)),
            Text('Ketersediaan: ${book.availability ?? ''}', style: const TextStyle(fontSize: 18)),
            Text('Review: ${book.review ?? ''}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            const Text(
              'Sinopsis: ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(book.sinopsis ?? '', style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
