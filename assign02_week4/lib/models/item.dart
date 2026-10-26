// ============================================================
// OOP: ABSTRACTION — abstract class định nghĩa "vật phẩm thư viện"
// ============================================================
abstract class LibraryItem {
  final String id;
  String name;

  LibraryItem({required this.id, required this.name});

  // Abstract method — mọi item phải tự mô tả
  String describe();

  @override
  String toString() => describe();
}
