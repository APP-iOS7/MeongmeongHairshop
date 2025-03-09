import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import '../providers/user_provider.dart';

// 회원가입 처리
Future<void> signUp(
  BuildContext context,
  UserProvider userProvider,
  PetProvider petProvider,
) async {
  try {
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: userProvider.user.email.trim(),
          password: userProvider.password,
        );

    // Firestore에 정보 저장
    var db = FirebaseFirestore.instance;

    final user = userProvider.user.toFirestore();

    await db
        .collection("users")
        .doc(credential.user!.uid)
        .set(user)
        .onError((e, _) => debugPrint("Error writing document: $e"));

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("회원가입 성공! 로그인 페이지로 이동합니다.")));

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  } on FirebaseAuthException catch (e) {
    debugPrint('회원가입 오류: ${e.code} - ${e.message}');

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('회원가입에 실패했습니다.')));
  } catch (e) {
    debugPrint('예상치 못한 오류: $e');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("예상치 못한 오류가 발생했습니다.")));
  }
}

// 유효성 검사 메서드
bool validateUserInfo(BuildContext context, GlobalKey<FormState> formKey) {
  final userProvider = Provider.of<UserProvider>(context, listen: false);

  if (formKey.currentState!.validate() && userProvider.passwordMatch) {
    return true;
  } else {
    if (!userProvider.passwordMatch) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("비밀번호가 일치하지 않습니다.")));
    }
    return false;
  }
}
