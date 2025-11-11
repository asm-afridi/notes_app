import 'package:flutter/material.dart';
import '../db/auth_database.dart';

class AuthService extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _currentUser;
  int? _userId;

  bool get isLoggedIn => _isLoggedIn;
  String? get currentUser => _currentUser;
  int? get userId => _userId;

  // Login
  Future<bool> login(String username, String password) async {
    final userId = await AuthDatabase.instance.loginUser(username, password);
    if (userId != null) {
      _isLoggedIn = true;
      _currentUser = username;
      _userId = userId;
      notifyListeners();
      return true;
    }
    return false;
  }

  // Register
  Future<bool> register(String username, String password) async {
    final userId = await AuthDatabase.instance.registerUser(username, password);
    if (userId != null) {
      _isLoggedIn = true;
      _currentUser = username;
      _userId = userId;
      notifyListeners();
      return true;
    }
    return false;
  }

  // Logout
  void logout() {
    _isLoggedIn = false;
    _currentUser = null;
    _userId = null;
    notifyListeners();
  }
}
