import 'package:flutter/foundation.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  final User _user = User(email: '', username: '', phoneNumber: '');

  String _password = '';
  String _confirmPassword = '';
  bool _passwordMatch = true;

  User get user => _user;
  String get password => _password;
  bool get passwordMatch => _passwordMatch;

  void updateEmail(String email) {
    _user.email = email;
    notifyListeners();
  }

  void updatePassword(String password) {
    _password = password;
    _checkPasswordMatch(password, _confirmPassword);
    notifyListeners();
  }

  void updateConfirmPassword(String confirmPassword) {
    _confirmPassword = confirmPassword;
    _checkPasswordMatch(_password, confirmPassword);
    notifyListeners();
  }

  void updateUsername(String username) {
    _user.username = username;
    notifyListeners();
  }

  void updatePhoneNumber(String phoneNumber) {
    _user.phoneNumber = phoneNumber;
    notifyListeners();
  }

  // 비밀번호가 일치하는지 확인하는 함수
  void _checkPasswordMatch(String password, String confirmPassword) {
    if (password == confirmPassword) {
      _passwordMatch = true;
    } else {
      _passwordMatch = false;
    }
  }
}
