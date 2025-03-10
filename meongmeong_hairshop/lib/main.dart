// Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'config/app_theme.dart';
import 'routes.dart';
// Provider
import 'package:meongmeong_hairshop/providers/reservation_provider.dart';
import 'package:meongmeong_hairshop/providers/user_provider.dart';
import 'package:meongmeong_hairshop/providers/pet_provider.dart';
import 'package:provider/provider.dart';

import 'views/auth/login_screen.dart';
import 'views/home/main_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  // 날짜 한글화
  await initializeDateFormatting();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // 에뮬레이터 사용
<<<<<<< HEAD
  // FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  // FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
=======
  FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
>>>>>>> c5f37f8720059231c616986a981bc2253f501317

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => PetProvider()),
        ChangeNotifierProvider(create: (context) => ReservationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: buildLightTheme(),
      home: AuthWrapper(),
      routes: appRoutes,
    );
  }
}

// 인증 상태에 따라 화면 분기
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<UserProvider>(
              context,
              listen: false,
            ).fetchUserfromFirebase();

            final currentUser = auth.FirebaseAuth.instance.currentUser;
            final userId = currentUser!.uid;
            Provider.of<PetProvider>(
              context,
              listen: false,
            ).fetchPetsFromFirestore(userId);
          });
          return MainScreen();
        }

        return LoginScreen();
      },
    );
  }
}
