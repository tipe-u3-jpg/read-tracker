import 'package:flutter/material.dart';

import 'dart:convert';

import 'book_details_screen.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Book {
  String id;
  String title;
  String author;
  int year;
  String notes;
  String? imageUrl;
  String status;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.year,
    required this.notes,
    this.imageUrl,
    this.status = 'Plan',
  });

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'author': author,
      'year': year,
      'notes': notes,
      'imageUrl': imageUrl,
      'status': status,
    };
  }

  factory Book.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Book(
      id: doc.id,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      year: data['year']?.toInt() ?? 0,
      notes: data['notes'] ?? '',
      imageUrl: data['imageUrl'],
      status: data['status'] ?? 'Plan',
    );
  }
}


//Book стара версія
/*
class Book {
  String id;
  String title;
  String author;
  int year;
  String notes;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.year,
    required this.notes,
  });

  // Перетворення об'єкта в Map (для JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'year': year,
      'notes': notes,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] ?? DateTime.now().toString(),
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      year: map['year']?.toInt() ?? 0,
      notes: map['notes'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Book.fromJson(String source) => Book.fromMap(json.decode(source));
}
*/

class BooksTab extends StatefulWidget {
  const BooksTab({super.key});

  @override
  State<BooksTab> createState() => _BooksTabState();
}

class _BooksTabState extends State<BooksTab> {

  /*
  void _showBookDialog({Book? book}) {
    final isEditing = book != null;
    final titleController = TextEditingController(text: isEditing ? book.title : '');
    final authorController = TextEditingController(text: isEditing ? book.author : '');
    final yearController = TextEditingController(text: isEditing ? book.year.toString() : '');
    final notesController = TextEditingController(text: isEditing ? book.notes : '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Редагувати книжку' : 'Додати книжку'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Назва')),
                TextField(controller: authorController, decoration: const InputDecoration(labelText: 'Автор')),
                TextField(controller: yearController, decoration: const InputDecoration(labelText: 'Рік'), keyboardType: TextInputType.number),
                TextField(controller: notesController, decoration: const InputDecoration(labelText: 'Нотатки'), maxLines: 3),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Відмінити')),
            ElevatedButton(
              onPressed: () {
                final newBook = Book(
                  id: isEditing ? book.id : DateTime.now().toString(), // Генеруємо ID
                  title: titleController.text.isEmpty ? 'Без назви' : titleController.text,
                  author: authorController.text.isEmpty ? 'Невідомий' : authorController.text,
                  year: int.tryParse(yearController.text) ?? 2024,
                  notes: notesController.text,
                );

                Provider.of<BookProvider>(context, listen: false).addOrUpdateBook(newBook);

                Navigator.pop(context);
              },
              child: const Text('Зберегти'),
            ),
          ],
        );
      },
    );
  }
  */
  void _showBookDialog({Book? book}) {
    final isEditing = book != null;
    final titleController = TextEditingController(text: isEditing ? book.title : '');
    final authorController = TextEditingController(text: isEditing ? book.author : '');
    final yearController = TextEditingController(text: isEditing ? book.year.toString() : '');
    final notesController = TextEditingController(text: isEditing ? book.notes : '');
    File? selectedImage;

    // Змінна для статусу (за замовчуванням 'Plan')
    String currentStatus = isEditing ? book.status : 'Plan';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(isEditing ? 'Редагувати книжку' : 'Додати книжку'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    // ... (тут твій код з вибором фото) ...
                    // --- ПОЧАТОК БЛОКУ ФОТО ---
                    GestureDetector(
                      onTap: () async {
                        final picker = ImagePicker();
                        final pickedFile = await picker.pickImage(source: ImageSource.gallery);

                        if (pickedFile != null) {
                          setState(() {
                            selectedImage = File(pickedFile.path);
                          });
                        }
                      },
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: selectedImage != null
                            ? Image.file(selectedImage!, fit: BoxFit.cover) // Показуємо нове фото з телефону
                            : (isEditing && book.imageUrl != null)
                            ? Image.network(book.imageUrl!, fit: BoxFit.cover) // Або старе з інтернету
                            : const Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // --- КІНЕЦЬ БЛОКУ ФОТО ---
                    TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Назва')),
                    TextField(controller: authorController, decoration: const InputDecoration(labelText: 'Автор')),
                    TextField(controller: yearController, decoration: const InputDecoration(labelText: 'Рік'), keyboardType: TextInputType.number),
                    TextField(controller: notesController, decoration: const InputDecoration(labelText: 'Нотатки'), maxLines: 3),

                    const SizedBox(height: 10),
                    // ВИБІР СТАТУСУ
                    DropdownButtonFormField<String>(
                      value: currentStatus,
                      decoration: const InputDecoration(labelText: 'Статус читання'),
                      items: const [
                        DropdownMenuItem(value: 'Plan', child: Text('Планую')),
                        DropdownMenuItem(value: 'Reading', child: Text('Читаю')),
                        DropdownMenuItem(value: 'Done', child: Text('Прочитав')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          currentStatus = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Відмінити')),
                ElevatedButton(
                  onPressed: () {
                    final provider = Provider.of<BookProvider>(context, listen: false);

                    final tempBook = Book(
                      id: isEditing ? book.id : '',
                      title: titleController.text.isEmpty ? 'Без назви' : titleController.text,
                      author: authorController.text.isEmpty ? 'Невідомий' : authorController.text,
                      year: int.tryParse(yearController.text) ?? 2024,
                      notes: notesController.text,
                      imageUrl: isEditing ? book.imageUrl : null,
                      status: currentStatus, // <-- ЗАПИСУЄМО СТАТУС
                    );

                    if (isEditing) {
                      provider.updateBook(tempBook, selectedImage);
                    } else {
                      provider.addBookWithImage(tempBook, selectedImage);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Зберегти'),
                ),
              ],
            );
          },
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text(
              'Мої книжки',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4F92FF)),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: Consumer<BookProvider>(
                builder: (context, bookProvider, child) {
                  if (bookProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (bookProvider.books.isEmpty) {
                    return const Center(child: Text('Список порожній'));
                  }

                  return ListView.builder(
                    itemCount: bookProvider.books.length,
                    itemBuilder: (context, index) {
                      final book = bookProvider.books[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        color: Colors.white,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          /*
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFF4F92FF),
                            child: Text(book.year.toString().substring(2),
                                style: const TextStyle(color: Colors.white)),
                          ),
                           */
                          leading: book.imageUrl != null
                              ? Image.network(book.imageUrl!, width: 50, height: 50, fit: BoxFit.cover)
                              : CircleAvatar(
                            backgroundColor: const Color(0xFF4F92FF),
                            child: Text(book.year.toString().substring(2),
                                style: const TextStyle(color: Colors.white)),
                          ),
                          title: Text(book.title,
                              style:
                              const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(book.author),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BookDetailsScreen(book: book)),
                            );
                          },
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _showBookDialog(book: book),
                              ),
                              IconButton(
                                icon:
                                const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  // Видалення через провайдер
                                  bookProvider.deleteBook(book.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4F92FF),
        onPressed: () => _showBookDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

  /*
  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: bookProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text('Мої книжки', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF4F92FF))),
            const SizedBox(height: 20),

            Expanded(
              child: bookProvider.books.isEmpty
                  ? const Center(child: Text('Список порожній'))
                  : ListView.builder(
                itemCount: bookProvider.books.length,
                itemBuilder: (context, index) {
                  final book = bookProvider.books[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    color: Colors.white,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFF4F92FF),
                        child: Text(book.year.toString().substring(2), style: const TextStyle(color: Colors.white)),
                      ),
                      title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(book.author),
                      onTap: () {
                        //1.1b
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BookDetailsScreen(book: book)),
                        );
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showBookDialog(book: book),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              bookProvider.deleteBook(book.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4F92FF),
        onPressed: () => _showBookDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
*/




/*
class _BooksTabState extends State<BooksTab> {
  final List<Book> _books = [
    // Дефолтні книжки для статистики
    Book(title: '1984', author: 'Джордж Орвелл', year: 1949, notes: 'Антиутопія'),
    Book(title: 'Маленький принц', author: 'Антуан де Сент-Екзюпері', year: 1943, notes: 'Філософська казка'),
    Book(title: 'Гаррі Поттер', author: 'Дж.К. Роулінг', year: 1997, notes: ''),
  ];

  void _showBookDialog({Book? book, int? index}) {
    final titleController =
    TextEditingController(text: book != null ? book.title : '');
    final authorController =
    TextEditingController(text: book != null ? book.author : '');
    final yearController =
    TextEditingController(text: book != null ? book.year.toString() : '');
    final notesController =
    TextEditingController(text: book != null ? book.notes : '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(book == null ? 'Додати книжку' : 'Редагувати книжку'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Назва'),
                ),
                TextField(
                  controller: authorController,
                  decoration: const InputDecoration(labelText: 'Автор'),
                ),
                TextField(
                  controller: yearController,
                  decoration: const InputDecoration(labelText: 'Рік'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'Нотатки'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Відмінити'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  final newBook = Book(
                    title: titleController.text.isEmpty
                        ? 'Нова книжка'
                        : titleController.text,
                    author: authorController.text.isEmpty
                        ? 'Автор'
                        : authorController.text,
                    year: int.tryParse(yearController.text) ?? 2000,
                    notes: notesController.text.isEmpty
                        ? 'Тут можна додати нотатки'
                        : notesController.text,
                  );

                  if (book == null) {
                    _books.add(newBook);
                  } else if (index != null) {
                    _books[index] = newBook;
                  }
                });
                Navigator.pop(context);
              },
              child: Text(book == null ? 'Додати' : 'Зберегти'),
            ),
          ],
        );
      },
    ).then((_) {
      titleController.dispose();
      authorController.dispose();
      yearController.dispose();
      notesController.dispose();
    });
  }

  void _deleteBook(int index) {
    setState(() {
      _books.removeAt(index);
    });
  }

  Widget _buildStatistics() {
    final totalBooks = _books.length;
    final avgYear = _books.isNotEmpty
        ? (_books.map((b) => b.year).reduce((a, b) => a + b) ~/ totalBooks)
        : 0;
    final notesCount = _books.where((b) => b.notes.isNotEmpty).length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF4F92FF),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statCard(Icons.book, 'Книжок', totalBooks),
          _statCard(Icons.calendar_today, 'Середній рік', avgYear),
          _statCard(Icons.note, 'Нотаток', notesCount),
        ],
      ),
    );
  }

  Widget _statCard(IconData icon, String label, int value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 6),
        Text(
          '$value',
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFF5F5F5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Мої книжки',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4F92FF),
              ),
            ),
            const SizedBox(height: 20),
            _buildStatistics(),
            const SizedBox(height: 20),
            Expanded(
              child: _books.isEmpty
                  ? const Center(
                child: Text(
                  'Список книжок поки порожній.',
                  style: TextStyle(fontSize: 18, color: Colors.black87),
                ),
              )
                  : ListView.builder(
                itemCount: _books.length,
                itemBuilder: (context, index) {
                  final book = _books[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F92FF),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.menu_book,
                          size: 40,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Назва: ${book.title}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              Text('Автор: ${book.author}',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.white70)),
                              Text('Рік: ${book.year}',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.white70)),
                              Text('Нотатки: ${book.notes}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white70)),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Colors.white),
                              onPressed: () =>
                                  _showBookDialog(book: book, index: index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.redAccent),
                              onPressed: () => _deleteBook(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4F92FF),
        onPressed: () => _showBookDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

*/








/*
import 'package:flutter/material.dart';

class BooksTab extends StatelessWidget {
  const BooksTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFF5F5F5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Мої книжки',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4F92FF),
              ),
            ),
            const SizedBox(height: 20),
            const Expanded(
              child: Center(
                child: Text(
                  'Список книжок поки порожній.',
                  style: TextStyle(fontSize: 18, color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4F92FF),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Додавання книжок ще не реалізовано')),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
*/



