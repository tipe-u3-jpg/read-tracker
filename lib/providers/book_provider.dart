import 'dart:io';
import 'package:flutter/material.dart';
import '../screens/books_screen.dart';
import '../repositories/book_repository.dart';

class BookProvider extends ChangeNotifier {
  final BookRepository _repository = BookRepository();

  List<Book> _books = [];
  bool _isLoading = false;

  List<Book> get books => _books;
  bool get isLoading => _isLoading;

  BookProvider() {
    _listenToBooks();
  }

  void _listenToBooks() {
    _isLoading = true;
    notifyListeners();

    _repository.getBooks().listen((booksData) {
      _books = booksData;
      _isLoading = false;
      notifyListeners();
    }, onError: (error) {
      print("Error listening to books: $error");
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> addBookWithImage(Book book, File? imageFile) async {
    try {
      String? imageUrl;

      if (imageFile != null) {
        _isLoading = true;
        notifyListeners();
        imageUrl = await _repository.uploadImage(imageFile);
      }

      final newBook = Book(
        id: '',
        title: book.title,
        author: book.author,
        year: book.year,
        notes: book.notes,
        imageUrl: imageUrl,
      );

      await _repository.addBook(newBook);

    } catch (e) {
      print("Error adding book: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateBook(Book book, File? newImageFile) async {
    try {
      String? imageUrl = book.imageUrl;

      if (newImageFile != null) {
        _isLoading = true;
        notifyListeners();
        imageUrl = await _repository.uploadImage(newImageFile);
      }

      final updatedBook = Book(
        id: book.id,
        title: book.title,
        author: book.author,
        year: book.year,
        notes: book.notes,
        imageUrl: imageUrl,
        status: book.status,
      );

      await _repository.updateBook(updatedBook);
    } catch (e) {
      print("Error updating book: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteBook(String id) async {
    await _repository.deleteBook(id);
  }
}



//book_provider(LAB-5.Version)
/*
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/books_screen.dart'; // Імпорт класу Book (або зміни шлях, якщо виніс Book в models)

class BookProvider extends ChangeNotifier {
  List<Book> _books = [];
  bool _isLoading = false;

  List<Book> get books => _books;
  bool get isLoading => _isLoading;

  BookProvider() {
    loadBooks();
  }

  Future<void> loadBooks() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final List<String>? booksJson = prefs.getStringList('books');

    if (booksJson != null) {
      _books = booksJson.map((str) => Book.fromJson(str)).toList();
    } else {
      _books = [
        Book(id: '1', title: '1984', author: 'Джордж Орвелл', year: 1949, notes: 'Антиутопія'),
        Book(id: '2', title: 'Маленький принц', author: 'Антуан де Сент-Екзюпері', year: 1943, notes: 'Філософська казка'),
      ];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addOrUpdateBook(Book book) async {
    final index = _books.indexWhere((b) => b.id == book.id);
    if (index >= 0) {
      _books[index] = book;
    } else {
      _books.add(book);
    }
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> deleteBook(String id) async {
    _books.removeWhere((b) => b.id == id);
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> booksJson = _books.map((b) => b.toJson()).toList();
    await prefs.setStringList('books', booksJson);
  }
}
*/
