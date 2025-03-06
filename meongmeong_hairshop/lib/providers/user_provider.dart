import 'package:flutter/foundation.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User _user = User(email: '', password: '', username: '', phoneNumber: '');

  String _confirmPassword = '';
  bool _passwordMatch = true;

  User get user => _user;
  String get confirmPassword => _confirmPassword;
  bool get passwordMatch => _passwordMatch;

  void updateEmail(String email) {
    _user.email = email;
    notifyListeners();
  }

  void updatePassword(String password) {
    _user.password = password;
    _checkPasswordMatch(password, _confirmPassword);
    notifyListeners();
  }

  void updateConfirmPassword(String confirmPassword) {
    _confirmPassword = confirmPassword;
    _checkPasswordMatch(_user.password, confirmPassword);
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

  void updateUsername(String username) {
    _user.username = username;
    notifyListeners();
  }

  void updatePhoneNumber(String phoneNumber) {
    _user.phoneNumber = phoneNumber;
    notifyListeners();
  }
}
