import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

Future<void> signIn(BuildContext context) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);

  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: userProvider.user.email,
          password: userProvider.password,
        );
    Navigator.pushNamedAndRemoveUntil(context, '/success', (route) => false);
    debugPrint('로그인 성공: ${userCredential.user}');
  } catch (e) {
    debugPrint('로그인 실패: ${e.toString()}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("로그인에 실패했습니다. 정확한 이메일 비밀번호를 입력하세요.")),
    );
  }
}
