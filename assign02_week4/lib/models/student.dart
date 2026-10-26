import 'item.dart';
import 'book.dart';

// ============================================================
// OOP: INHERITANCE — Student kế thừa LibraryItem
// OOP: ENCAPSULATION — _borrowedBooks private
// ============================================================
class Student extends LibraryItem {
  final String studentId;
  final List<Book> _borrowedBooks = [];

  Student({
    required super.id,
    required super.name,
    required this.studentId,
  });

  // Getter — đọc danh sách sách đã mượn (unmodifiable)
  List<Book> get borrowedBooks => List.unmodifiable(_borrowedBooks);

  int get borrowCount => _borrowedBooks.length;

  // Mượn sách
  void borrowBook(Book book) {
    book.borrow(); // Encapsulation: gọi method của Book
    _borrowedBooks.add(book);
  }

  // Trả sách
  void returnBook(Book book) {
    book.returnBook();
    _borrowedBooks.removeWhere((b) => b.id == book.id);
  }

  // OOP: POLYMORPHISM — override describe()
  @override
  String describe() =>
      'Sinh viên: $name | MSSV: $studentId | Đang mượn: $borrowCount sách';
}
