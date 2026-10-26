import 'package:flutter/material.dart';
import '../models/library.dart';

// Tab DS Sách — hiển thị toàn bộ sách + trạng thái
class BooksScreen extends StatelessWidget {
  final Library library;
  final VoidCallback onDataChanged;

  const BooksScreen({
    super.key,
    required this.library,
    required this.onDataChanged,
  });

  @override
  Widget build(BuildContext context) {
    final books = library.books;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Danh sách Sách',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: books.isEmpty
                  ? const Center(child: Text('Chưa có sách nào.'))
                  : ListView.separated(
                      itemCount: books.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (ctx, i) {
                        final book = books[i];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          leading: CircleAvatar(
                            backgroundColor: book.isBorrowed
                                ? Colors.red.shade100
                                : Colors.blue.shade100,
                            child: Icon(
                              book.isBorrowed
                                  ? Icons.menu_book
                                  : Icons.book_outlined,
                              color: book.isBorrowed
                                  ? Colors.red.shade700
                                  : const Color(0xFF1565C0),
                            ),
                          ),
                          title: Text(
                            book.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text('Tác giả: ${book.author}'),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: book.isBorrowed
                                  ? Colors.red.shade50
                                  : Colors.green.shade50,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: book.isBorrowed
                                    ? Colors.red.shade300
                                    : Colors.green.shade300,
                              ),
                            ),
                            child: Text(
                              book.isBorrowed ? 'Đang mượn' : 'Có sẵn',
                              style: TextStyle(
                                fontSize: 12,
                                color: book.isBorrowed
                                    ? Colors.red.shade700
                                    : Colors.green.shade700,
                              ),
                            ),
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
