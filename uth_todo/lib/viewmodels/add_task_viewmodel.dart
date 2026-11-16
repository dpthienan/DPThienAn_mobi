import 'package:flutter/material.dart';

import '../models/teach_task.dart';
import '../services/task_api.dart';

enum TaskDateOption { today, tomorrow, thisWeek }

/// ViewModel của màn hình "Việc mới".
///
/// Giữ toàn bộ trạng thái form (tiêu đề, ghi chú, nhóm, ngày, giờ, nhắc nhở,
/// mức ưu tiên) và gọi API khi lưu. View chỉ lắng nghe và render.
class AddTaskViewModel extends ChangeNotifier {
  static const categories = [
    (id: 'study', label: 'Học tập'),
    (id: 'life', label: 'Cuộc sống'),
  ];

  static const priorities = [
    (id: 'low', label: 'Thấp'),
    (id: 'medium', label: 'Vừa'),
    (id: 'high', label: 'Cao'),
  ];

  static const dateOptions = [
    (id: TaskDateOption.today, label: 'Hôm nay'),
    (id: TaskDateOption.tomorrow, label: 'Ngày mai'),
    (id: TaskDateOption.thisWeek, label: 'Tuần này'),
  ];

  String title = '';
  String note = '';
  String category = 'study';
  TaskDateOption dateOption = TaskDateOption.today;
  TimeOfDay time = const TimeOfDay(hour: 19, minute: 0);
  bool remind = true;
  String priority = 'medium';

  bool saving = false;
  String? error;

  bool _disposed = false;

  bool get canSave => title.trim().isNotEmpty && !saving;

  String get timeLabel =>
      '${time.hour.toString().padLeft(2, '0')}:'
      '${time.minute.toString().padLeft(2, '0')}';

  /// Ngày dạng yyyy-MM-dd gửi lên API.
  String get dateLabel {
    final date = _resolveDate(DateTime.now());
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  void setTitle(String value) {
    if (title == value) return;
    title = value;
    _notify();
  }

  void setNote(String value) {
    if (note == value) return;
    note = value;
    _notify();
  }

  void setCategory(String value) {
    if (category == value) return;
    category = value;
    _notify();
  }

  void setDateOption(TaskDateOption value) {
    if (dateOption == value) return;
    dateOption = value;
    _notify();
  }

  void setTime(TimeOfDay value) {
    if (time == value) return;
    time = value;
    _notify();
  }

  void setRemind(bool value) {
    if (remind == value) return;
    remind = value;
    _notify();
  }

  void setPriority(String value) {
    if (priority == value) return;
    priority = value;
    _notify();
  }

  /// Gọi API tạo việc. Trả về task vừa tạo, hoặc null nếu lỗi.
  Future<TeachTask?> save() async {
    final trimmed = title.trim();
    if (trimmed.isEmpty || saving) return null;

    saving = true;
    error = null;
    _notify();
    try {
      final created = await TaskApi.instance.createTask(
        title: trimmed,
        note: note.trim(),
        category: category,
        date: dateLabel,
        time: timeLabel,
        priority: priority,
        remind: remind,
      );
      saving = false;
      _notify();
      return created;
    } catch (e) {
      saving = false;
      error = 'Không lưu được: $e';
      _notify();
      return null;
    }
  }

  DateTime _resolveDate(DateTime now) {
    switch (dateOption) {
      case TaskDateOption.today:
        return now;
      case TaskDateOption.tomorrow:
        return now.add(const Duration(days: 1));
      case TaskDateOption.thisWeek:
        // Chủ nhật của tuần hiện tại (nếu hôm nay là Chủ nhật thì lấy hôm nay).
        return now.add(Duration(days: 7 - now.weekday));
    }
  }

  void _notify() {
    if (_disposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
