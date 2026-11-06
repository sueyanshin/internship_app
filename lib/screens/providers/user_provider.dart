import 'package:flutter/material.dart';
import 'package:job_app/models/user_model.dart';
import 'package:job_app/service/auth_service.dart';

class UserProvider extends ChangeNotifier {
  final AuthService _authService;

  UserProvider(this._authService);

  UserModel? _currentUser;
  bool _isLoading = false;
  String _errorMessage = "";

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchUserProfile() async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      _currentUser = await _authService.getCurrentUser();
    } catch (e) {
      _errorMessage = 'Error fetching user profile: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }
}
