/// Kelas yang merepresentasikan sebuah buku dalam aplikasi.
///
/// Kelas ini memiliki atribut-atribut seperti judul, penulis, penerbit, tahun terbit,
/// ISBN, ketersediaan, review, dan sinopsis sebuah buku. Kelas ini juga menyediakan
/// metode-metode untuk mengonversi objek [Book] menjadi [Map] dan sebaliknya.
class Book {
  int? id;
  String? title;
  String? author;
  String? publisher;
  int? publishYear;
  String? isbn;
  int? availability;
  String? review;
  String? sinopsis;

  Book({
    this.id,
    this.title,
    this.author,
    this.publisher,
    this.publishYear,
    this.isbn,
    this.availability,
    this.review,
    this.sinopsis,
  });

  /// Mengonversi objek [Book] menjadi [Map] yang dapat digunakan untuk penyimpanan
  /// atau pembaruan data buku di database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'publisher': publisher,
      'publishYear': publishYear,
      'isbn': isbn,
      'availability': availability,
      'review': review,
      'sinopsis': sinopsis,
    };
  }

  /// Membuat objek [Book] dari [Map] yang digunakan untuk membaca data buku dari database.
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      publisher: map['publisher'],
      publishYear: map['publishYear'],
      isbn: map['isbn'],
      availability: map['availability'],
      review: map['review'],
      sinopsis: map['sinopsis'],
    );
  }
}
