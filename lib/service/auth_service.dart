import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:job_app/models/user_model.dart';

class AuthService {
  AuthService(this._auth, this._firestore);

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _isInitialized = false;
  drive.DriveApi? _cacheDriveApi;
  final clientId = dotenv.env['clientId'];
  final serverClientId = dotenv.env['serverClientId'];

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;
  drive.DriveApi? get driveApi => _cacheDriveApi;

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await GoogleSignIn.instance.initialize(
        clientId: clientId,
        serverClientId: serverClientId,
      );

      _isInitialized = true;
    }
  }

  static const List<String> _driveScopes = [drive.DriveApi.driveFileScope];

  // sign in and get drive api
  Future<User?> signInAndGetDriveApi() async {
    try {
      await _ensureInitialized();

      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(
        scopeHint: _driveScopes,
      );

      final GoogleSignInClientAuthorization authorization = await googleUser
          .authorizationClient
          .authorizeScopes(_driveScopes);

      final credential = GoogleAuthProvider.credential(
        accessToken: authorization.accessToken,
        idToken: googleUser.authentication.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      debugPrint("Signed in as: ${userCredential.user?.displayName}");

      final authClient = authorization.authClient(scopes: _driveScopes);
      _cacheDriveApi = drive.DriveApi(authClient);

      final user = userCredential.user;
      final userDoc = _firestore.collection('users').doc(user!.uid);

      final snapshot = await userDoc.get();

      if (!snapshot.exists) {
        await userDoc.set({
          'uid': user.uid,
          'name': user.displayName ?? "",
          'email': user.email ?? "",
          'phone': "",
          'profileUrl': user.photoURL ?? "",
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return user;
    } catch (e) {
      debugPrint("Google Sign-In Error: $e");
      return null;
    }
  }

  // restore drive api for active session
  Future<drive.DriveApi> getActiveDriveApi() async {
    if (_cacheDriveApi != null) return _cacheDriveApi!;

    await _ensureInitialized();

    final googleUser = await _googleSignIn.attemptLightweightAuthentication();
    if (googleUser == null) {
      throw Exception("Session expired. Please sign in again");
    }
    final authorization = await googleUser.authorizationClient.authorizeScopes(
      _driveScopes,
    );

    final authClient = authorization.authClient(scopes: _driveScopes);
    _cacheDriveApi = drive.DriveApi(authClient);
    return _cacheDriveApi!;
  }

  Future<String?> signUp(
    String name,
    String email,
    String password,
    String phoneNumber,
    String profileUrl,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        // save to users document
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': user.email,
          'phone': phoneNumber,
          'profileUrl': profileUrl,
          'createdAt': FieldValue.serverTimestamp(),
        });

        return null;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return _mapAuthError(e);
    } catch (e) {
      return ('Failed to create account profile. Please try again.');
    }
  }

  Future<void> saveProfileImageUrl({
    required String uid,
    required String profileUrl,
    required String driveFileId,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'profileUrl': profileUrl,
      'driveFileId': driveFileId,
      'isProfileCompleted': true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<String?> fetchProfileImageUrl(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data()!['profileUrl'] as String?;
  }

  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return _mapAuthError(e);
    } catch (_) {
      return ("Something went wrong. Please try again.");
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    _cacheDriveApi = null;
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        return UserModel.fromDocument(doc);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching usr: $e');
      return null;
    }
  }

  // update user info
  Future<void> updateUserProfile(String docId, UserModel user) async {
    try {
      final userData = user.toMap();
      userData['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('users').doc(docId).update(userData);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'weak-password':
        return 'Please choose a stronger password.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
