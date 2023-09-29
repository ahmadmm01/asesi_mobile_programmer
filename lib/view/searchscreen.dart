// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../controller/database.dart';
import '../model/book_model.dart';

/// Halaman pencarian buku yang memungkinkan pengguna melakukan pencarian
/// dan menampilkan hasil pencarian dalam daftar buku.
///
/// Stateful widget ini digunakan untuk membuat tampilan halaman pencarian
/// yang memungkinkan pengguna untuk mencari buku berdasarkan judul dan
/// menampilkan hasil pencarian dalam [Card] yang berisi detail buku.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Book> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchTextChanged);
  }

  /// Callback yang dipanggil ketika teks pencarian berubah.
  void _onSearchTextChanged() {
    String searchTerm = _searchController.text;
    if (searchTerm.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }
    _searchBooks(searchTerm);
  }

  /// Mencari buku berdasarkan kata kunci pencarian dan memperbarui tampilan.
  Future<void> _searchBooks(String searchTerm) async {
    List<Book> searchedBooks = await _databaseHelper.searchBooks(searchTerm);
    setState(() {
      _searchResults = searchedBooks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final book = _searchResults[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      book.title ?? '',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Penulis: ${book.author ?? ''}'),
                        Text('Penerbit: ${book.publisher ?? ''}'),
                        Text('Tahun Terbit: ${book.publishYear ?? ''}'),
                        Text('ISBN: ${book.isbn ?? ''}'),
                        Text('Status: ${book.availability == 1 ? 'Tersedia' : 'Dipinjam'}'),
                        Text('Review: ${book.review ?? ''}')                        
                      ],
                    ),
                    trailing: book.availability == 1
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : const Icon(Icons.cancel,
                            color: Colors
                                .red), // Menampilkan ikon status ketersediaan
                    // Anda dapat menambahkan fungsi onTap di sini untuk navigasi ke halaman detail buku
                    onTap: () {},
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
