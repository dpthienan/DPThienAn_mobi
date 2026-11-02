import 'package:cloud_firestore/cloud_firestore.dart';

class TodoItem {
  const TodoItem({
    required this.id,
    required this.title,
    required this.category,
    required this.time,
    required this.done,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String category;
  final String time;
  final bool done;
  final DateTime createdAt;

  static const categories = ['Học tập', 'Cuộc sống'];

  TodoItem copyWith({
    String? title,
    String? category,
    String? time,
    bool? done,
  }) {
    return TodoItem(
      id: id,
      title: title ?? this.title,
      category: category ?? this.category,
      time: time ?? this.time,
      done: done ?? this.done,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'time': time,
      'done': done,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory TodoItem.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return TodoItem(
      id: doc.id,
      title: data['title'] as String? ?? '',
      category: data['category'] as String? ?? 'Cuộc sống',
      time: data['time'] as String? ?? '09:00',
      done: data['done'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
