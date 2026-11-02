import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'analytics_service.dart';

class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickAndUploadAvatar() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError('Chưa đăng nhập.');
    }

    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (picked == null) return null;

    final ref = _storage.ref().child('users/${user.uid}/avatar.jpg');
    await ref.putFile(
      File(picked.path),
      SettableMetadata(contentType: 'image/jpeg'),
    );
    final url = await ref.getDownloadURL();
    await user.updatePhotoURL(url);
    await user.reload();
    await AnalyticsService.instance.logUploadAvatar();
    return url;
  }
}
