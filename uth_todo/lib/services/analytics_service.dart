import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  AnalyticsService._();
  static final AnalyticsService instance = AnalyticsService._();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logLogin(String method) {
    return _analytics.logLogin(loginMethod: method);
  }

  Future<void> logAddTodo(String category) {
    return _analytics.logEvent(
      name: 'add_todo',
      parameters: {'category': category},
    );
  }

  Future<void> logToggleTodo({required bool done}) {
    return _analytics.logEvent(
      name: 'toggle_todo',
      parameters: {'done': done ? 1 : 0},
    );
  }

  Future<void> logUploadAvatar() {
    return _analytics.logEvent(name: 'upload_avatar');
  }

  Future<void> setUserId(String? uid) {
    return _analytics.setUserId(id: uid);
  }
}
