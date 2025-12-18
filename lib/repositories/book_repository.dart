import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'dart:io';
import '../screens/books_screen.dart';

class BookRepository {
  // 1. ПІДКЛЮЧЕННЯ ДО FIREBASE (БАЗА ДАНИХ)
  final CollectionReference _booksCollection =
  FirebaseFirestore.instance.collection('books');

  // Отримати список книг (з Firebase)
  Stream<List<Book>> getBooks() {
    return _booksCollection
        .orderBy('year', descending: true) // Сортуємо за роком
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Book.fromFirestore(doc)).toList();
    });
  }

  // Додати книгу (в Firebase)
  Future<void> addBook(Book book) async {
    await _booksCollection.add(book.toFirestore());
  }

  // Оновити книгу (в Firebase)
  Future<void> updateBook(Book book) async {
    await _booksCollection.doc(book.id).update(book.toFirestore());
  }

  // Видалити книгу (з Firebase)
  Future<void> deleteBook(String id) async {
    await _booksCollection.doc(id).delete();
  }

  // 2. ЗАВАНТАЖЕННЯ ФОТО (SUPABASE STORAGE)
  Future<String> uploadImage(File imageFile) async {
    try {
      // Генеруємо унікальне ім'я файлу (наприклад, 174582938.jpg)
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = 'covers/$fileName'; // Шлях усередині сховища

      // Завантажуємо файл у Bucket з назвою 'book_covers'
      await Supabase.instance.client.storage
          .from('book_covers')
          .upload(path, imageFile);

      // Отримуємо публічне посилання на файл
      final imageUrl = Supabase.instance.client.storage
          .from('book_covers')
          .getPublicUrl(path);

      return imageUrl; // Повертаємо посилання, щоб записати його в Firebase
    } catch (e) {
      throw Exception('Помилка завантаження фото в Supabase: $e');
    }
  }
}


/*
class BookRepository {
  final CollectionReference _booksCollection =
  FirebaseFirestore.instance.collection('books');

  Stream<List<Book>> getBooks() {
    return _booksCollection.orderBy('year', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Book.fromFirestore(doc)).toList();
    });
  }

  Future<void> addBook(Book book) async {
    await _booksCollection.add(book.toFirestore());
  }

  Future<void> updateBook(Book book) async {
    await _booksCollection.doc(book.id).update(book.toFirestore());
  }

  Future<void> deleteBook(String id) async {
    await _booksCollection.doc(id).delete();
  }

  Future<String> uploadImage(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference ref = FirebaseStorage.instance.ref().child('book_covers/$fileName');

    UploadTask uploadTask = ref.putFile(imageFile);
    TaskSnapshot snapshot = await uploadTask;

    return await snapshot.ref.getDownloadURL();
  }
}
*/