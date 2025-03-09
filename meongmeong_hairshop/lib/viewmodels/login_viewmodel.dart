import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

Future<void> signIn(BuildContext context, String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    // 로그인 성공 후 사용자 데이터 로드 (네비게이션 전에 실행)
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadUserData();

    // 데이터 로드 후 네비게이션
    if (context.mounted) {
      // context가 여전히 유효한지 확인
      Navigator.pushNamed(context, '/success');
    }

    debugPrint('로그인 성공: ${userCredential.user}');
  } catch (e) {
    debugPrint('로그인 실패: ${e.toString()}');
    if (context.mounted) {
      // context가 여전히 유효한지 확인
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("로그인에 실패했습니다. 정확한 이메일 비밀번호를 입력하세요.")),
      );
    }
  }
}

Future<void> signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();

    if (context.mounted) {
      // context가 여전히 유효한지 확인
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  } catch (e) {
    debugPrint('로그아웃 오류: $e');

    if (context.mounted) {
      // context가 여전히 유효한지 확인
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('로그아웃에 실패했습니다.')));
    }
  }
}
