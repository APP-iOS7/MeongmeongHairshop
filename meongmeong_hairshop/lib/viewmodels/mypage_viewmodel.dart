import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/pet.dart';
import '../models/reservation.dart';

class MyPageViewModel with ChangeNotifier {
  User? _user;
  Pet? _pet;
  List<Reservation> _reservations = [];

  User? get user => _user;
  Pet? get pet => _pet;
  List<Reservation> get reservations => _reservations;

  // 사용자 정보 가져오는 로직 (예시)
  Future<void> fetchUserData() async {
    // 사용자 정보 가져오기
    _user = User(email: 'test@example.com', password: '', username: '테스트', phoneNumber: '010-1234-5678');
    _pet = Pet(name: '멍멍이', breed: '푸들', ageMonths: 12);
    notifyListeners();
  }

  // 예약 목록 가져오는 로직 (예시)
  Future<void> fetchReservations() async {
    // 예약 목록 가져오기
    _reservations = [
      Reservation(name: '', address: '', openTime: TimeOfDay.now(), closeTime: TimeOfDay.now(), date: DateTime.now(), reservedTime: '', designer: '', services: {}, petName: ''),
      // ...
    ];
    notifyListeners();
  }
}