import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  String _password = '';
  bool _passwordMatch = true;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  String get password => _password;
  bool get passwordMatch => _passwordMatch;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void initNewUser() {
    _user = User(email: '', username: '', phoneNumber: '');
    _password = '';
    _passwordMatch = true;
    _error = null;
    notifyListeners();
  }

  void updateEmail(String email) {
    _user?.email = email;
    notifyListeners();
  }

  void updatePassword(String password) {
    _password = password;
    notifyListeners();
  }

  void updateUsername(String username) {
    _user?.username = username;
    notifyListeners();
  }

  void updatePhoneNumber(String phoneNumber) {
    _user?.phoneNumber = phoneNumber;
    notifyListeners();
  }

  /* User 데이터를 파이어스토에서 로드
   * _isLoading: Bool => 데이터 로드 상태
   * _error: String => "에러메세지"
   */
  Future<void> fetchUserfromFirebase() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final currentUser = auth.FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        _error = '로그인이 필요합니다';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final docSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .get();

      if (docSnapshot.exists) {
        _user = User.fromFirestore(docSnapshot.data() as Map<String, dynamic>);
      } else {
        _error = '사용자 정보를 찾을 수 없습니다';
      }
    } catch (e) {
      _error = '사용자 정보를 로드 오류: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 사용자 정보 업데이트
  Future<bool> updateUserData({
    required String username,
    required String phoneNumber,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final currentUser = auth.FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        _error = '로그인이 필요합니다';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final updatedUser = User(
        email: _user!.email,
        username: username,
        phoneNumber: phoneNumber,
      );

      // Firestore 업데이트
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update(updatedUser.toFirestore());

      _user = updatedUser;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = '회원 정보 업데이트 오류: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
