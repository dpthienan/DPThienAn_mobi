import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'analytics_service.dart';
import 'messaging_service.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Web client ID from google-services.json (client_type: 3). Required so
  // Google Sign-In returns an idToken Firebase Auth can verify.
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId:
        '659566886823-urdudvt1gkfumfd5rsdkd3jjcgrh9u03.apps.googleusercontent.com',
  );

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw FirebaseAuthException(
        code: 'aborted-by-user',
        message: 'Đăng nhập Google đã bị hủy.',
      );
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final result = await _auth.signInWithCredential(credential);
    await AnalyticsService.instance.logLogin('google');
    await AnalyticsService.instance.setUserId(result.user?.uid);
    await MessagingService.instance.init();
    return result;
  }

  Future<void> signOut() async {
    await AnalyticsService.instance.setUserId(null);
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }
}
