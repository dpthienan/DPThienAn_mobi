import '../models/book.dart';
import '../models/student.dart';
import '../models/library.dart';

// ============================================================
// Dữ liệu mẫu khởi tạo sẵn cho app
// ============================================================
class LibraryData {
  static Library createSampleLibrary() {
    final lib = Library(name: 'Thư viện UTH');

    // Sách mẫu
    lib.addBook(Book(id: 'b1', name: 'Sách 01', author: 'Tác giả A'));
    lib.addBook(Book(id: 'b2', name: 'Sách 02', author: 'Tác giả B'));
    lib.addBook(Book(id: 'b3', name: 'Sách 03', author: 'Tác giả C'));

    // Sinh viên mẫu
    lib.addStudent(Student(id: 's1', name: 'Nguyen Van A', studentId: 'SV001'));
    lib.addStudent(Student(id: 's2', name: 'Tran Thi B', studentId: 'SV002'));

    return lib;
  }
}
