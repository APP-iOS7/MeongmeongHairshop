import 'package:flutter/material.dart';
import 'views/login_screen.dart';
import 'views/signup_screen.dart';

// 경로를 관리하는 함수
Map<String, Widget Function(BuildContext)> appRoutes = {
  '/login': (context) => LoginScreen(),
  '/signup': (context) => SignupScreen(),
  // '/success': (context) => ShopListScreen(),
};
