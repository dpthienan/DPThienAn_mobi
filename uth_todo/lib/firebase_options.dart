import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web chưa cấu hình Firebase cho bài này.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError('iOS chưa cấu hình Firebase.');
      default:
        throw UnsupportedError(
          'Chạy trên Android emulator. Windows/Chrome không dùng được Google Auth bài này.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBj4SEXTN-vV5IXLmQBdkkBf_cqee37nG4',
    appId: '1:659566886823:android:62ce85d246edac1a2d4082',
    messagingSenderId: '659566886823',
    projectId: 'uthtodo-25493',
    storageBucket: 'uthtodo-25493.firebasestorage.app',
  );
}
