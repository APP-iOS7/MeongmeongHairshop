import 'package:flutter/foundation.dart';
import 'package:meongmeong_hairshop/models/pet.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User _user = User(
    email: '',
    password: '',
    username: '',
    phoneNumber: '',
    pet: Pet(name: '', breed: '', ageMonths: 0),
  );

  String _confirmPassword = '';
  bool _passwordMatch = true;
  bool _isPetAgeNum = true;

  User get user => _user;
  String get confirmPassword => _confirmPassword;
  bool get passwordMatch => _passwordMatch;
  bool get isPetAgeNum => _isPetAgeNum;

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

  void updateUsername(String username) {
    _user.username = username;
    notifyListeners();
  }

  void updatePhoneNumber(String phoneNumber) {
    _user.phoneNumber = phoneNumber;
    notifyListeners();
  }

  void updatePetName(String petName) {
    _user.pet.name = petName;
    notifyListeners();
  }

  void updatePetBreed(String petBreed) {
    _user.pet.breed = petBreed;
    notifyListeners();
  }

  void updatePetAgeMonth(String petAgeMonth) {
    _checkAgeValue(petAgeMonth);
    if (_isPetAgeNum) {
      _user.pet.ageMonths = int.parse(petAgeMonth);
    }
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

  void _checkAgeValue(String input) {
    final age = int.tryParse(input);
    if (age == null || age <= 0) {
      _isPetAgeNum = false;
    } else {
      _isPetAgeNum = true;
    }
  }
}
