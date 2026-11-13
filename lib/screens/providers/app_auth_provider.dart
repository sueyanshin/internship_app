import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_app/models/user_model.dart';
import 'package:job_app/screens/providers/bottom_nav_provider.dart';
import 'package:job_app/service/auth_service.dart';
import 'package:job_app/service/drive_storage_service.dart';

class AppAuthProvider extends ChangeNotifier {
  final BottomNavProvider _navProvider = BottomNavProvider();
  final AuthService _authService;
  final DriveStorageService _driveStorageService;

  final ImagePicker _picker = ImagePicker();

  User? _firebaseUser;
  bool _isLoading = false;
  bool _isProfileLoading = false;
  bool _isImageUploading = false;
  bool _isAuthInitialized = false;
  StreamSubscription<User?>? _authSubscription;
  UserModel? _userProfile;

  XFile? _pickedImage;
  String? _profileUrl;
  String? _errorMessage;

  User? get firebaseUser => _firebaseUser;
  bool get isLoading => _isLoading;
  bool get isProfileLoading => _isProfileLoading;
  bool get isImageUploading => _isImageUploading;
  bool get isAuthInitialized => _isAuthInitialized;
  String? get errorMessage => _errorMessage;

  XFile? get pickedImage => _pickedImage;
  String? get profileUrl => _profileUrl;
  UserModel? get userProfile => _userProfile;
  bool get needsProfileSetup {
    return _firebaseUser != null && _userProfile?.isProfileCompleted != true;
  }

  AppAuthProvider(this._authService, this._driveStorageService) {
    _authSubscription = _authService.authStateChanges.listen((User? user) {
      _handleAuthStateChanged(user);
      notifyListeners();
    });
  }

  Future<void> _handleAuthStateChanged(User? user) async {
    _firebaseUser = user;
    if (user == null) {
      _userProfile = null;
      _profileUrl = null;
      _isProfileLoading = false;
      _isAuthInitialized = true;
      notifyListeners();
      return;
    }
    _isAuthInitialized = true;
    _isProfileLoading = true;
    notifyListeners();

    await _loadUserProfile(user);
  }

  Future<void> _loadUserProfile(User user) async {
    try {
      final profile = await _authService.getCurrentUser();

      if (_firebaseUser?.uid != user.uid) return;

      _userProfile = profile;
      _profileUrl = profile!.profileUrl ?? user.photoURL;

      // debugPrint('Firebase User: ${_firebaseUser?.uid}');
      // debugPrint('Profile: ${_userProfile?.profileUrl}');
      // debugPrint('Auth Initialized: $_isAuthInitialized');
      // debugPrint('Profile Loading: $_isProfileLoading');
      // debugPrint('Needs Setup: $needsProfileSetup');
    } catch (e) {
      _errorMessage = "Failed to load profile: $e";
    } finally {
      _isProfileLoading = false;
      notifyListeners();
    }
  }

  // fetch user data
  Future<void> fetchUserProfile() async {
    final user = _firebaseUser;

    if (user == null) {
      _userProfile = null;
      return;
    }

    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      await _loadUserProfile(user);
    } catch (e) {
      _errorMessage = 'Error fetching user profile: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearUser() {
    _userProfile = null;
    _profileUrl = null;
    _pickedImage = null;
    notifyListeners();
  }

  // Pick image form gallery
  Future<void> pickImage() async {
    try {
      final XFile? selected = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      if (selected != null) {
        _pickedImage = selected;
        _errorMessage = null;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = "Failed to pick image";
      notifyListeners();
    }
  }

  Future<bool> saveImage() async {
    if (_firebaseUser == null) {
      _errorMessage = "Please sign in first";
      notifyListeners();
      return false;
    }
    if (_pickedImage == null) {
      _errorMessage = "Please pick a profile image";
      notifyListeners();
      return false;
    }
    _isImageUploading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final driveApi = await _authService.getActiveDriveApi();

      // upload to drive
      final result = await _driveStorageService.uploadProfileImage(
        driveApi: driveApi,
        imageFile: File(_pickedImage!.path),
        userId: _firebaseUser!.uid,
      );
      final newPhotoUrl = result['profileUrl']!;
      final fileId = result['fileId'];

      // save URL to firestore
      await _authService.saveProfileImageUrl(
        uid: _firebaseUser!.uid,
        profileUrl: newPhotoUrl,
        driveFileId: fileId!,
      );

      _profileUrl = newPhotoUrl;
      _pickedImage = null;
      await fetchUserProfile();
      return true;
    } catch (e) {
      _errorMessage = 'Upload failed: $e';
      return false;
    } finally {
      _isImageUploading = false;
      notifyListeners();
    }
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _firebaseUser = await _authService.signInAndGetDriveApi();
      return _firebaseUser != null;
    } catch (e) {
      _errorMessage = 'Authentication failed: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Email Registration
  Future<String?> signUp(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final error = await _authService.signUp(name, email, password, phone, "");
      _errorMessage = error;
      return error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      return await _authService.signIn(email, password);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.signOut();
      _navProvider.changeIndex(0);
    } catch (e) {
      _errorMessage = 'Sign out failed: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserProfile(
    String docId,
    String name,
    String phone,
    String currentEmail,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedUser = UserModel(
        uid: docId,
        name: name,
        email: currentEmail,
        phone: phone,
      );
      await _authService.updateUserProfile(docId, updatedUser);
      fetchUserProfile();
    } catch (e) {
      _errorMessage = 'Update failed: $e';
    } finally {
      _isLoading = false;
      fetchUserProfile();
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
