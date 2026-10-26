import 'package:flutter/material.dart';
import '../models/library.dart';
import '../models/student.dart';

// Tab Sinh viên — hiển thị danh sách SV + sách đang mượn
class StudentsScreen extends StatefulWidget {
  final Library library;
  final VoidCallback onDataChanged;

  const StudentsScreen({
    super.key,
    required this.library,
    required this.onDataChanged,
  });

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  void _addStudent() async {
    final nameCtrl = TextEditingController();
    final idCtrl = TextEditingController();
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Thêm sinh viên'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Họ và tên'),
            ),
            TextField(
              controller: idCtrl,
              decoration: const InputDecoration(labelText: 'MSSV'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () {
              final name = nameCtrl.text.trim();
              final sid = idCtrl.text.trim();
              if (name.isNotEmpty && sid.isNotEmpty) {
                final uid = 's${DateTime.now().millisecondsSinceEpoch}';
                widget.library
                    .addStudent(Student(id: uid, name: name, studentId: sid));
                widget.onDataChanged();
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0)),
            child:
                const Text('Thêm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _returnBook(Student student, String bookId) {
    final msg = widget.library.returnBook(student.id, bookId);
    widget.onDataChanged();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final students = widget.library.students;

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: _addStudent,
        backgroundColor: const Color(0xFF1565C0),
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Danh sách Sinh viên',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: students.isEmpty
                  ? const Center(child: Text('Chưa có sinh viên nào.'))
                  : ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (ctx, i) {
                        final sv = students[i];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: ExpansionTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.shade100,
                              child: Text(
                                sv.name[0].toUpperCase(),
                                style: const TextStyle(
                                    color: Color(0xFF1565C0),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: Text(sv.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                            subtitle: Text(
                                'MSSV: ${sv.studentId} · ${sv.borrowCount} sách'),
                            children: sv.borrowedBooks.isEmpty
                                ? [
                                    const Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Text('Chưa mượn sách nào.',
                                          style: TextStyle(
                                              color: Colors.grey)),
                                    )
                                  ]
                                : sv.borrowedBooks
                                    .map(
                                      (b) => ListTile(
                                        dense: true,
                                        leading: const Icon(Icons.menu_book,
                                            color: Color(0xFF1565C0)),
                                        title: Text(b.name),
                                        subtitle: Text('Tác giả: ${b.author}'),
                                        trailing: TextButton(
                                          onPressed: () =>
                                              _returnBook(sv, b.id),
                                          child: const Text('Trả',
                                              style: TextStyle(
                                                  color: Colors.red)),
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
