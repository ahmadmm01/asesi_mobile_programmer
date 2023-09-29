// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'book_detail.dart';
import '../controller/database.dart';
import '../model/book_model.dart';

/// Halaman utama aplikasi yang menampilkan daftar buku, fungsi pencarian, dan pesan jika buku tidak ditemukan.
///
/// Stateful widget ini digunakan untuk membuat tampilan halaman utama
/// yang memungkinkan pengguna melakukan pencarian buku berdasarkan judul
/// dan menampilkan daftar buku yang sesuai. Jika buku tidak ditemukan,
/// akan ditampilkan pesan yang sesuai.
///
/// Daftar buku ditampilkan dalam [Card] yang berisi judul buku, penulis,
/// review, status ketersediaan, dan opsi untuk melihat detail buku.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Book> _books = [];
  final TextEditingController _searchController = TextEditingController();
  bool _booksNotFound = false; // Tambahkan variabel ini

  @override
  void initState() {
    super.initState();
    _loadBooks(); // Load books from the database when the screen initializes
  }

  /// Mengambil daftar buku dari database dan memperbarui tampilan.
  Future<void> _loadBooks() async {
    List<Book> books = await _databaseHelper.getBooks();
    setState(() {
      _books = books;
    });
  }

  /// Mencari buku berdasarkan kata kunci pencarian dan memperbarui tampilan.
  Future<void> _searchBooks(String searchTerm) async {
    List<Book> searchedBooks = await _databaseHelper.searchBooks(searchTerm);
    if (searchedBooks.isEmpty) {
      setState(() {
        _booksNotFound = true; // Set variabel ini jika buku tidak ditemukan
        _books = searchedBooks;
      });
    } else {
      setState(() {
        _booksNotFound = false; // Set variabel ini jika buku ditemukan
        _books = searchedBooks;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pencarian Buku'),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Cari buku...',
                  prefixIcon: Icon(Icons.search),
                ),
                onSubmitted: (searchTerm) {
                  _searchBooks(searchTerm);
                },
              ),
            ),
            // Tambahkan kondisi untuk menampilkan pesan jika buku tidak ditemukan
            if (_booksNotFound)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Buku tidak ditemukan.',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: _books.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(_books[index].title ?? ''),
                      subtitle: Column(
                        children: [
                          Row(
                            children: [
                              Text(_books[index].author ?? ''),
                              Text(_books[index].review ?? ''),
                            ],
                          ),
                        ],
                      ),
                      trailing: _books[index].availability == 1
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.cancel, color: Colors.red),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BookDetailPage(book: _books[index]),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
