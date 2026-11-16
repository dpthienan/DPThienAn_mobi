import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationKind { upcoming, overdue, achievement, reminder }

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.read = false,
    this.kind = NotificationKind.reminder,
    this.timeLabel,
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool read;
  final NotificationKind kind;

  /// Nhãn thời gian hiển thị ở góc phải thẻ (vd: "13:45", "Hôm qua").
  final String? timeLabel;

  AppNotification copyWith({bool? read}) {
    return AppNotification(
      id: id,
      title: title,
      body: body,
      createdAt: createdAt,
      read: read ?? this.read,
      kind: kind,
      timeLabel: timeLabel,
    );
  }

  factory AppNotification.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return AppNotification(
      id: doc.id,
      title: data['title'] as String? ?? '',
      body: data['body'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      read: data['read'] as bool? ?? false,
      kind: _parseKind(data['kind']),
      timeLabel: data['timeLabel'] as String?,
    );
  }
}

NotificationKind _parseKind(Object? raw) {
  switch (raw) {
    case 'upcoming':
      return NotificationKind.upcoming;
    case 'overdue':
      return NotificationKind.overdue;
    case 'achievement':
      return NotificationKind.achievement;
    default:
      return NotificationKind.reminder;
  }
}
