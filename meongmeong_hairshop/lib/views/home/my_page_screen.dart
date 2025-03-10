import 'package:flutter/material.dart';
import 'package:meongmeong_hairshop/models/pet.dart';
import 'package:meongmeong_hairshop/providers/pet_provider.dart';
import 'package:meongmeong_hairshop/providers/user_provider.dart';
import 'package:meongmeong_hairshop/viewmodels/login_viewmodel.dart';
import 'package:provider/provider.dart';

class MyPageScreen extends StatelessWidget {
  MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('마이페이지')),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfile(context),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/editProfile'),
              child: Text('회원 정보 수정'),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/managePet'),
              child: Text('반려 동물 관리'),
            ),
            TextButton(onPressed: () {
              Navigator.pushNamed(context, '/reservationList');
            }, child: Text('예약 내역')),
            TextButton(
              onPressed: () => _showLogoutConfirmationDialog(context),
              child: Text('로그아웃'),
            ),
          ],
        ),
      ),
    );
  }
}

void _showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('로그아웃'),
        content: Text('정말 로그아웃 하시겠습니까?'),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              signOut(context);
              PetProvider petProvider = Provider.of<PetProvider>(
                context,
                listen: false,
              );
              petProvider.resetAll();
            },
            child: Text('로그아웃'),
          ),
        ],
      );
    },
  );
}

Widget _buildProfile(BuildContext context) {
  final userProvider = Provider.of<UserProvider>(context);

  if (userProvider.user == null) {
    return const Center(child: CircularProgressIndicator());
  }

  return Padding(
    padding: const EdgeInsets.all(10),
    child: Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 139, 216, 142),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            userProvider.user!.username,
            style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.0),
          Text(
            '이메일: ${userProvider.user!.email}',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 8.0),
          Text(
            '전화번호: ${userProvider.user!.phoneNumber}',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    ),
  );
}
