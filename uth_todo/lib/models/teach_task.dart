class Subtask {
  const Subtask({required this.title, required this.done});

  final String title;
  final bool done;

  factory Subtask.fromJson(Map<String, dynamic> json) {
    return Subtask(
      title: json['title'] as String? ?? '',
      done: json['done'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {'title': title, 'done': done};
}

class TeachTask {
  const TeachTask({
    required this.id,
    required this.title,
    required this.note,
    required this.category,
    required this.date,
    required this.time,
    required this.priority,
    required this.remind,
    required this.done,
    required this.subtasks,
  });

  final int id;
  final String title;
  final String note;
  final String category;
  final String date;
  final String time;
  final String priority;
  final bool remind;
  final bool done;
  final List<Subtask> subtasks;

  static const categoryLabels = {
    'study': 'Học tập',
    'life': 'Cuộc sống',
  };

  static const priorityLabels = {
    'high': 'Cao',
    'medium': 'Trung bình',
    'low': 'Thấp',
  };

  String get categoryLabel => categoryLabels[category] ?? category;
  String get priorityLabel => priorityLabels[priority] ?? priority;

  int get subtaskDoneCount => subtasks.where((s) => s.done).length;

  factory TeachTask.fromJson(Map<String, dynamic> json) {
    final rawSubs = json['subtasks'];
    return TeachTask(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      note: json['note'] as String? ?? '',
      category: json['category'] as String? ?? 'life',
      date: json['date'] as String? ?? '',
      time: json['time'] as String? ?? '',
      priority: json['priority'] as String? ?? 'medium',
      remind: json['remind'] as bool? ?? false,
      done: json['done'] as bool? ?? false,
      subtasks: rawSubs is List
          ? rawSubs
              .whereType<Map<String, dynamic>>()
              .map(Subtask.fromJson)
              .toList()
          : const [],
    );
  }
}
