import 'package:flutter/material.dart';

import '../models/teach_task.dart';
import '../services/task_api.dart';
import '../services/task_store.dart';
import '../theme/app_colors.dart';

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final int taskId;

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  TeachTask? _task;
  String? _error;
  bool _loading = true;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final task = await TaskApi.instance.fetchTask(widget.taskId);
      if (!mounted) return;
      setState(() {
        _task = task;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _markDone() async {
    final task = _task;
    if (task == null) return;
    setState(() => _busy = true);
    try {
      final updated = await TaskApi.instance.patchTask(task.id, {
        'done': !task.done,
      });
      await TaskStore.instance.refresh();
      if (!mounted) return;
      setState(() {
        _task = updated;
        _busy = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không cập nhật được: $e')),
      );
    }
  }

  Future<void> _delete() async {
    final task = _task;
    if (task == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa công việc'),
        content: Text('Xóa “${task.title}”?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _busy = true);
    try {
      await TaskApi.instance.deleteTask(task.id);
      await TaskStore.instance.refresh();
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không xóa được: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = _task;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.text,
        elevation: 0,
        title: const Text('Chi tiết'),
        actions: [
          if (task != null)
            TextButton(
              onPressed: _busy ? null : _delete,
              child: const Text('Xóa', style: TextStyle(color: Colors.redAccent)),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                )
              : task == null
                  ? const SizedBox.shrink()
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                      children: [
                        Text(
                          task.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _chip(task.categoryLabel, AppColors.purpleSoft, AppColors.purple),
                            _chip(task.priorityLabel, const Color(0xFFFFF4E8), AppColors.orange),
                            if (task.remind)
                              _chip('Nhắc nhở', const Color(0xFFE8F8EE), AppColors.green),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _infoRow(Icons.event, 'Hạn', task.date),
                        _infoRow(Icons.schedule, 'Giờ', task.time),
                        if (task.note.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Text(
                            'Ghi chú',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          Text(task.note, style: const TextStyle(color: AppColors.muted, height: 1.4)),
                        ],
                        if (task.subtasks.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          Text(
                            'Việc con  ${task.subtaskDoneCount}/${task.subtasks.length}',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          ...task.subtasks.map(
                            (s) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(
                                s.done ? Icons.check_circle : Icons.radio_button_unchecked,
                                color: s.done ? AppColors.purple : AppColors.muted,
                              ),
                              title: Text(
                                s.title,
                                style: TextStyle(
                                  decoration: s.done ? TextDecoration.lineThrough : null,
                                  color: s.done ? AppColors.muted : AppColors.text,
                                ),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _busy ? null : _markDone,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.purple,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              task.done ? 'Đánh dấu chưa xong' : 'Đánh dấu hoàn thành',
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _busy ? null : _delete,
                          child: const Text(
                            'Xóa công việc',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      ],
                    ),
    );
  }

  Widget _chip(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(
        label,
        style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.purple),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(color: AppColors.muted)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
