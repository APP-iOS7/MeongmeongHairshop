import 'package:flutter/material.dart';
import 'package:meongmeong_hairshop/models/pet.dart';
import 'package:meongmeong_hairshop/models/reservation.dart';
import 'package:meongmeong_hairshop/models/salon.dart';
import 'package:meongmeong_hairshop/models/user.dart';

import '../models/user.dart';
import '../models/pet.dart';
import '../models/salon.dart';
import '../models/reservation.dart';

class SignupViewModel with ChangeNotifier {
  User? _user;
  Pet? _pet;
  Salon? _salon;
  Reservation? _reservation;

  User? get user => _user;
  Pet? get pet => _pet;
  Salon? get salon => _salon;
  Reservation? get reservation => _reservation;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void setPet(Pet pet) {
    _pet = pet;
    notifyListeners();
  }

  void setSalon(Salon salon) {
    _salon = salon;
    notifyListeners();
  }

  void setReservation(Reservation reservation) {
    _reservation = reservation;
    notifyListeners();
  }

  Future<void> signup() async {
    // ...
    
  }
}