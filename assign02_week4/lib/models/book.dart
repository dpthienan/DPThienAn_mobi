import 'item.dart';

// ============================================================
// OOP: INHERITANCE — Book kế thừa LibraryItem
// OOP: ENCAPSULATION — _isBorrowed private, chỉ đổi qua method
// ============================================================
class Book extends LibraryItem {
  final String author;
  bool _isBorrowed;

  Book({
    required super.id,
    required super.name,
    required this.author,
    bool isBorrowed = false,
  }) : _isBorrowed = isBorrowed;

  // Getter — đọc trạng thái mượn
  bool get isBorrowed => _isBorrowed;

  // Encapsulation: thay đổi trạng thái chỉ qua method
  void borrow() {
    if (_isBorrowed) throw Exception('Sách "$name" đã được mượn.');
    _isBorrowed = true;
  }

  void returnBook() {
    if (!_isBorrowed) throw Exception('Sách "$name" chưa được mượn.');
    _isBorrowed = false;
  }

  // OOP: POLYMORPHISM — override describe()
  @override
  String describe() => 'Sách: $name | Tác giả: $author | ${_isBorrowed ? "Đang mượn" : "Có sẵn"}';

  Book copyWith({String? name, String? author, bool? isBorrowed}) {
    return Book(
      id: id,
      name: name ?? this.name,
      author: author ?? this.author,
      isBorrowed: isBorrowed ?? _isBorrowed,
    );
  }
}
