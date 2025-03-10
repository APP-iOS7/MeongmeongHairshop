import 'package:flutter/material.dart';
import 'views/auth/edit_user_screen.dart';
import 'views/auth/login_screen.dart';
import 'views/home/main_screen.dart';
import 'views/auth/signup_pet_screen.dart';
import 'views/auth/signup_user_screen.dart';
import 'views/reservation/payment_screen.dart';
import 'views/reservation/reservation_detail_screen.dart';
import 'views/reservation/reservation_list_screen.dart';
import 'views/reservation/reservation_screen.dart';

// 경로를 관리하는 함수
Map<String, Widget Function(BuildContext)> appRoutes = {
  '/login': (context) => LoginScreen(),
  '/signup/user': (context) => SignupUserScreen(),
  '/signup/pet': (context) => SignupPetScreen(),
  '/success': (context) => MainScreen(),
  '/editProfile': (context) => EditUserScreen(),

  '/reservation': (context) => ReservationScreen(),
  '/payment': (context) => PaymentScreen(),
  '/reservationList': (context) => ReservationListScreen(),
  '/reservationDetail': (context) => ReservationDetailScreen(createdAt: ModalRoute.of(context)!.settings.arguments as String),
  // '/success': (context) => ShopListScreen(),
};
