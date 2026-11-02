import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/todo_item.dart';
import 'analytics_service.dart';

class TodoService {
  TodoService._();
  static final TodoService instance = TodoService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String get _uid {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError('Chưa đăng nhập — không dùng được Firestore.');
    }
    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _todos =>
      _db.collection('users').doc(_uid).collection('todos');

  CollectionReference<Map<String, dynamic>> get _notifications =>
      _db.collection('users').doc(_uid).collection('notifications');

  Stream<List<TodoItem>> watchTodos() {
    return _todos.orderBy('createdAt', descending: true).snapshots().map(
          (snap) => snap.docs.map(TodoItem.fromDoc).toList(),
        );
  }

  Future<void> addTodo({
    required String title,
    required String category,
    required String time,
  }) async {
    final doc = _todos.doc();
    final item = TodoItem(
      id: doc.id,
      title: title.trim(),
      category: category,
      time: time,
      done: false,
      createdAt: DateTime.now(),
    );
    await doc.set(item.toMap());
    await _notifications.add({
      'title': 'Việc mới',
      'body': 'Đã thêm: ${item.title}',
      'createdAt': FieldValue.serverTimestamp(),
      'read': false,
    });
    await AnalyticsService.instance.logAddTodo(category);
  }

  Future<void> toggleDone(TodoItem item) async {
    final next = !item.done;
    await _todos.doc(item.id).update({'done': next});
    if (next) {
      await _notifications.add({
        'title': 'Hoàn thành',
        'body': 'Bạn đã xong: ${item.title}',
        'createdAt': FieldValue.serverTimestamp(),
        'read': false,
      });
    }
    await AnalyticsService.instance.logToggleTodo(done: next);
  }

  Future<void> deleteTodo(String id) async {
    await _todos.doc(id).delete();
  }

  Future<void> ensureWelcomeSeed() async {
    final existing = await _todos.limit(1).get();
    if (existing.docs.isNotEmpty) return;

    final batch = _db.batch();
    final samples = [
      TodoItem(
        id: _todos.doc().id,
        title: 'Tập thể dục 30 phút',
        category: 'Cuộc sống',
        time: '06:30',
        done: true,
        createdAt: DateTime.now(),
      ),
      TodoItem(
        id: _todos.doc().id,
        title: 'Nộp bài tập Lập trình di động',
        category: 'Học tập',
        time: '09:00',
        done: true,
        createdAt: DateTime.now(),
      ),
      TodoItem(
        id: _todos.doc().id,
        title: 'Ôn chương 3 – Cấu trúc dữ liệu',
        category: 'Học tập',
        time: '14:00',
        done: false,
        createdAt: DateTime.now(),
      ),
      TodoItem(
        id: _todos.doc().id,
        title: 'Đi chợ mua đồ cho tuần',
        category: 'Cuộc sống',
        time: '17:30',
        done: false,
        createdAt: DateTime.now(),
      ),
    ];

    for (final item in samples) {
      batch.set(_todos.doc(item.id), item.toMap());
    }
    batch.set(_notifications.doc(), {
      'title': 'Chào mừng đến UTH Todo',
      'body': 'Todos của bạn đã được đồng bộ với Cloud Firestore.',
      'createdAt': FieldValue.serverTimestamp(),
      'read': false,
    });
    await batch.commit();
  }
}
