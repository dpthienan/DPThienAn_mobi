// ============================================================
// Hệ thống Quản lý Thư viện — Flutter + Dart
// Đủ 4 đặc trưng OOP:
//   1. Encapsulation  — _books, _students, _isBorrowed private; getter/setter
//   2. Inheritance    — Book, Student kế thừa LibraryItem
//   3. Polymorphism   — override describe() ở mỗi subclass
//   4. Abstraction    — abstract class LibraryItem với abstract method describe()
// ============================================================

import 'package:flutter/material.dart';
import 'data/library_data.dart';
import 'models/library.dart';
import 'screens/manage_screen.dart';
import 'screens/books_screen.dart';
import 'screens/students_screen.dart';

void main() {
  runApp(const LibraryApp());
}

class LibraryApp extends StatelessWidget {
  const LibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý Thư viện',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  late Library _library;

  @override
  void initState() {
    super.initState();
    _library = LibraryData.createSampleLibrary();
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final screens = [
      ManageScreen(library: _library, onDataChanged: _refresh),
      BooksScreen(library: _library, onDataChanged: _refresh),
      StudentsScreen(library: _library, onDataChanged: _refresh),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 0, // dùng SafeArea thay vì AppBar
      ),
      body: SafeArea(child: screens[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        selectedItemColor: const Color(0xFF1565C0),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Quản lý',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'DS Sách',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Sinh viên',
          ),
        ],
      ),
    );
  }
}
