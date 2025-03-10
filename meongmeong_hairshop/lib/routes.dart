import 'package:flutter/material.dart';

import 'views/login_screen.dart';
import 'views/shop_list_screen.dart';
import 'views/signup_pet_screen.dart';
import 'views/signup_user_screen.dart';
import 'views/reservation/payment_screen.dart';
import 'views/reservation/reservation_list_screen.dart';
import 'views/reservation/reservation_screen.dart';

// 경로를 관리하는 함수
Map<String, Widget Function(BuildContext)> appRoutes = {
  '/login': (context) => LoginScreen(),
  '/signup/user': (context) => SignupUserScreen(),
  '/signup/pet': (context) => SignupPetScreen(),
  '/success': (context) => ReservationScreen(), //temp

  '/reservation': (context) => ReservationScreen(),
  '/payment': (context) => PaymentScreen(),
  '/reservationList': (context) => ReservationListScreen(),
};
