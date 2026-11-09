import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/teach_task.dart';

class TaskApi {
  TaskApi._();
  static final TaskApi instance = TaskApi._();

  static const _base = 'https://share.tryapps.store/mock/teach/tasks';
  static const _token = 'TuanTruong-uth-student';

  Map<String, String> get _headers => {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Future<List<TeachTask>> fetchTasks() async {
    final res = await http.get(Uri.parse(_base), headers: _headers);
    _ensureOk(res, 'GET list');
    final data = jsonDecode(res.body);
    if (data is! List) {
      throw StateError('API list không trả về mảng.');
    }
    return data
        .whereType<Map<String, dynamic>>()
        .map(TeachTask.fromJson)
        .toList();
  }

  Future<TeachTask> fetchTask(int id) async {
    final res = await http.get(Uri.parse('$_base/$id'), headers: _headers);
    _ensureOk(res, 'GET /$id');
    return TeachTask.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<TeachTask> patchTask(int id, Map<String, dynamic> body) async {
    final res = await http.patch(
      Uri.parse('$_base/$id'),
      headers: _headers,
      body: jsonEncode(body),
    );
    _ensureOk(res, 'PATCH /$id');
    return TeachTask.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<TeachTask> createTask({
    required String title,
    required String category,
    required String time,
  }) async {
    final today = DateTime.now();
    final date =
        '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final res = await http.post(
      Uri.parse(_base),
      headers: _headers,
      body: jsonEncode({
        'title': title,
        'note': '',
        'category': category,
        'date': date,
        'time': time,
        'priority': 'medium',
        'remind': false,
        'done': false,
        'subtasks': <Map<String, dynamic>>[],
      }),
    );
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw StateError('POST thất bại (${res.statusCode}): ${res.body}');
    }
    if (res.body.isEmpty) {
      throw StateError('POST không trả dữ liệu.');
    }
    return TeachTask.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<void> deleteTask(int id) async {
    final res = await http.delete(Uri.parse('$_base/$id'), headers: _headers);
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw StateError('DELETE /$id thất bại (${res.statusCode}): ${res.body}');
    }
  }

  void _ensureOk(http.Response res, String action) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw StateError('$action thất bại (${res.statusCode}): ${res.body}');
    }
  }
}
