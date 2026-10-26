import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/library.dart';
import '../models/student.dart';

// Tab Quản lý: chọn sinh viên, chọn sách, mượn/trả
class ManageScreen extends StatefulWidget {
  final Library library;
  final VoidCallback onDataChanged;

  const ManageScreen({
    super.key,
    required this.library,
    required this.onDataChanged,
  });

  @override
  State<ManageScreen> createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  Student? _selectedStudent;
  final Set<String> _selectedBookIds = {};
  String _message = '';

  @override
  void initState() {
    super.initState();
    if (widget.library.students.isNotEmpty) {
      _selectedStudent = widget.library.students.first;
    }
  }

  void _changeStudent() async {
    final students = widget.library.students;
    final result = await showDialog<Student>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Chọn sinh viên'),
        children: students
            .map((s) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(ctx, s),
                  child: Text('${s.name} (${s.studentId})'),
                ))
            .toList(),
      ),
    );
    if (result != null) {
      setState(() {
        _selectedStudent = result;
        _selectedBookIds.clear();
        _message = '';
      });
    }
  }

  void _addBook() async {
    final controller = TextEditingController();
    final authorController = TextEditingController();
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Thêm sách mới'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: 'Tên sách'),
            ),
            TextField(
              controller: authorController,
              decoration: const InputDecoration(labelText: 'Tác giả'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();
              final author = authorController.text.trim();
              if (name.isNotEmpty) {
                final id = 'b${DateTime.now().millisecondsSinceEpoch}';
                widget.library.addBook(
                    Book(id: id, name: name, author: author.isEmpty ? 'Không rõ' : author));
                widget.onDataChanged();
                Navigator.pop(ctx);
                setState(() => _message = 'Đã thêm sách: $name');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1565C0)),
            child: const Text('Thêm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _borrowSelected() {
    if (_selectedStudent == null || _selectedBookIds.isEmpty) return;
    final messages = <String>[];
    for (final bookId in _selectedBookIds) {
      final msg = widget.library.borrowBook(_selectedStudent!.id, bookId);
      messages.add(msg);
    }
    widget.onDataChanged();
    setState(() {
      _selectedBookIds.clear();
      _message = messages.join('\n');
    });
  }

  @override
  Widget build(BuildContext context) {
    final books = widget.library.books;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề
            const Center(
              child: Text(
                'Hệ thống\nQuản lý Thư viện',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Sinh viên
            const Text(
              'Sinh viên',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _selectedStudent?.name ?? 'Chưa chọn',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _changeStudent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: const Text('Thay đổi', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Danh sách sách
            const Text(
              'Danh sách sách',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: books.isEmpty
                    ? const Center(child: Text('Chưa có sách nào'))
                    : ListView.separated(
                        padding: const EdgeInsets.all(8),
                        itemCount: books.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 6),
                        itemBuilder: (ctx, i) {
                          final book = books[i];
                          final selected = _selectedBookIds.contains(book.id);
                          return GestureDetector(
                            onTap: () {
                              if (book.isBorrowed) return;
                              setState(() {
                                if (selected) {
                                  _selectedBookIds.remove(book.id);
                                } else {
                                  _selectedBookIds.add(book.id);
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? const Color(0xFF1565C0)
                                          : book.isBorrowed
                                              ? Colors.grey.shade400
                                              : Colors.white,
                                      border: Border.all(
                                        color: selected
                                            ? const Color(0xFF1565C0)
                                            : Colors.grey.shade400,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: selected || book.isBorrowed
                                        ? const Icon(Icons.check,
                                            size: 14, color: Colors.white)
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      book.name,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: book.isBorrowed
                                            ? Colors.grey
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  if (book.isBorrowed)
                                    Text(
                                      'Đang mượn',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.red.shade400),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
            const SizedBox(height: 12),

            // Thông báo
            if (_message.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _message,
                  style: TextStyle(color: Colors.blue.shade800, fontSize: 13),
                ),
              ),
            if (_message.isNotEmpty) const SizedBox(height: 8),

            // Nút hành động
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _addBook,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Thêm',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
                if (_selectedBookIds.isNotEmpty) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _borrowSelected,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Mượn',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
