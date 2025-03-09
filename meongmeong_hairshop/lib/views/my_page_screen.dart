import 'package:flutter/material.dart';
import 'package:meongmeong_hairshop/providers/user_provider.dart';
import 'package:meongmeong_hairshop/viewmodels/login_viewmodel.dart';
import 'package:provider/provider.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('마이페이지')),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(onPressed: () {}, child: Text('회원 정보 수정')),
            TextButton(onPressed: () {}, child: Text('반려 동물 관리')),
            TextButton(onPressed: () {}, child: Text('예약 내역')),
            TextButton(onPressed: () => signOut(context), child: Text('로그아웃')),
          ],
        ),
      ),
    );
  }
}
