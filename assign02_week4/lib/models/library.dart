import 'book.dart';
import 'student.dart';

// ============================================================
// OOP: ENCAPSULATION — Library quản lý toàn bộ dữ liệu nội bộ
// ============================================================
class Library {
  final String name;
  final List<Book> _books = [];
  final List<Student> _students = [];

  Library({required this.name});

  // --- Books ---
  List<Book> get books => List.unmodifiable(_books);

  void addBook(Book book) => _books.add(book);

  void removeBook(String bookId) =>
      _books.removeWhere((b) => b.id == bookId);

  Book? findBook(String bookId) {
    try {
      return _books.firstWhere((b) => b.id == bookId);
    } catch (_) {
      return null;
    }
  }

  // --- Students ---
  List<Student> get students => List.unmodifiable(_students);

  void addStudent(Student student) => _students.add(student);

  void removeStudent(String studentId) =>
      _students.removeWhere((s) => s.id == studentId);

  Student? findStudent(String studentId) {
    try {
      return _students.firstWhere((s) => s.id == studentId);
    } catch (_) {
      return null;
    }
  }

  // --- Mượn / Trả sách ---
  String borrowBook(String studentId, String bookId) {
    final student = findStudent(studentId);
    final book = findBook(bookId);
    if (student == null) return 'Không tìm thấy sinh viên.';
    if (book == null) return 'Không tìm thấy sách.';
    try {
      student.borrowBook(book);
      return 'Mượn thành công: ${book.name}';
    } catch (e) {
      return e.toString().replaceAll('Exception: ', '');
    }
  }

  String returnBook(String studentId, String bookId) {
    final student = findStudent(studentId);
    final book = findBook(bookId);
    if (student == null) return 'Không tìm thấy sinh viên.';
    if (book == null) return 'Không tìm thấy sách.';
    try {
      student.returnBook(book);
      return 'Trả thành công: ${book.name}';
    } catch (e) {
      return e.toString().replaceAll('Exception: ', '');
    }
  }
}
