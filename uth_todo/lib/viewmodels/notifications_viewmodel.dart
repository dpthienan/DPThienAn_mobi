import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/app_notification.dart';

/// ViewModel của màn hình Thông báo.
///
/// - Giữ danh sách thông báo cho View hiển thị.
/// - Sau [autoClearAfter] (mặc định 10 giây) tự đưa danh sách về rỗng để
///   View chuyển sang giao diện emptyView.
class NotificationsViewModel extends ChangeNotifier {
  NotificationsViewModel({
    Duration autoClearAfter = const Duration(seconds: 10),
    List<AppNotification>? initialNotifications,
  }) : _items = initialNotifications ?? _seedNotifications() {
    _timer = Timer(autoClearAfter, clearAll);
  }

  Timer? _timer;
  List<AppNotification> _items;

  List<AppNotification> get notifications => List.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  int get unreadCount => _items.where((n) => !n.read).length;

  void markAllRead() {
    if (unreadCount == 0) return;
    _items = [for (final n in _items) n.copyWith(read: true)];
    notifyListeners();
  }

  void markRead(String id) {
    final index = _items.indexWhere((n) => n.id == id);
    if (index == -1 || _items[index].read) return;
    _items = [
      for (final n in _items)
        if (n.id == id) n.copyWith(read: true) else n,
    ];
    notifyListeners();
  }

  /// Đưa danh sách về rỗng -> View hiển thị emptyView.
  void clearAll() {
    if (_items.isEmpty) return;
    _items = const [];
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  static List<AppNotification> _seedNotifications() {
    final now = DateTime.now();
    return [
      AppNotification(
        id: 'upcoming-1',
        title: 'Sắp đến hạn',
        body: 'Ôn chương 3 – Cấu trúc dữ liệu lúc 14:00.',
        timeLabel: '13:45',
        kind: NotificationKind.upcoming,
        createdAt: now,
      ),
      AppNotification(
        id: 'overdue-1',
        title: 'Đã quá hạn',
        body: 'Bài đọc tham khảo môn Mạng máy tính chưa xong.',
        timeLabel: '10:10',
        kind: NotificationKind.overdue,
        createdAt: now,
      ),
      AppNotification(
        id: 'achievement-1',
        title: 'Làm tốt lắm!',
        body: 'Bạn đã xong 2 việc trong sáng nay.',
        timeLabel: '11:30',
        kind: NotificationKind.achievement,
        createdAt: now,
      ),
      AppNotification(
        id: 'reminder-1',
        title: 'Nhắc việc',
        body: 'Họp nhóm đã ổn trong tuần này.',
        timeLabel: 'Hôm qua',
        kind: NotificationKind.reminder,
        createdAt: now,
      ),
    ];
  }
}
