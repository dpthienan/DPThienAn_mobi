import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../models/app_notification.dart';

class MessagingService {
  MessagingService._();
  static final MessagingService instance = MessagingService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  bool _listening = false;

  Future<void> init() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      debugPrint('FCM permission: ${settings.authorizationStatus}');

      if (!_listening) {
        _listening = true;
        _messaging.onRegistered.listen((installationId) async {
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) return;
          await _db.collection('users').doc(user.uid).set({
            'fcmInstallationId': installationId,
            'email': user.email,
            'displayName': user.displayName,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        });

        FirebaseMessaging.onMessage.listen((message) {
          debugPrint('FCM foreground: ${message.notification?.title}');
        });
      }

      await _messaging.register();
    } catch (e, st) {
      debugPrint('Messaging init skipped: $e\n$st');
    }
  }

  Stream<List<AppNotification>> watchNotifications() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value(const []);
    }
    return _db
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(AppNotification.fromDoc).toList());
  }

  Future<void> markRead(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await _db
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .doc(id)
        .update({'read': true});
  }
}
