import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_app/service/auth_service.dart';

class AppAuthProvider extends ChangeNotifier {
  final AuthService _authService;
  User? _user;
  bool _isLoading = false;
  bool _isAuthInitialized = false;
  StreamSubscription<User?>? _authSubscription;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthInitialized => _isAuthInitialized;

  AppAuthProvider(this._authService) {
    _authSubscription = _authService.authStateChanges.listen((User? user) {
      _user = user;
      _isAuthInitialized = true;
      notifyListeners();
    });
  }

  Future<String?> signUp(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      return await _authService.signUp(email, password);
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
    await _authService.signOut();
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
