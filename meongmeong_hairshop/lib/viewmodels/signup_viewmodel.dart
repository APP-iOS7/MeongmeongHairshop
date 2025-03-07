import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

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
