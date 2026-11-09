import 'package:flutter/foundation.dart';

import '../models/teach_task.dart';
import 'task_api.dart';

class TaskStore extends ChangeNotifier {
  TaskStore._();
  static final TaskStore instance = TaskStore._();

  List<TeachTask> tasks = const [];
  bool loading = false;
  String? error;

  Future<void> refresh() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final items = await TaskApi.instance.fetchTasks();
      items.sort((a, b) {
        final byDate = a.date.compareTo(b.date);
        if (byDate != 0) return byDate;
        return a.time.compareTo(b.time);
      });
      tasks = items;
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> toggleDone(TeachTask task) async {
    final updated = await TaskApi.instance.patchTask(task.id, {
      'done': !task.done,
    });
    _replace(updated);
  }

  Future<void> remove(int id) async {
    await TaskApi.instance.deleteTask(id);
    tasks = tasks.where((t) => t.id != id).toList();
    notifyListeners();
  }

  void _replace(TeachTask task) {
    tasks = [
      for (final item in tasks)
        if (item.id == task.id) task else item,
    ];
    notifyListeners();
  }
}
