import 'package:flutter/material.dart';
import '../models/reservation.dart';

class ReservationViewModel with ChangeNotifier {
  Reservation? _reservation;

  Reservation? get reservation => _reservation;

  void setReservation(Reservation reservation) {
    _reservation = reservation;
    notifyListeners();
  }

  // 예약 저장 로직 (예시)
  Future<void> saveReservation() async {
    // ...
  }
}