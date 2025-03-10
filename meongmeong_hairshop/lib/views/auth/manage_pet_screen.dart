import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:meongmeong_hairshop/providers/pet_provider.dart';
import 'package:provider/provider.dart';

import '../../widgets/display_pet_list.dart';

class ManagePetScreen extends StatelessWidget {
  const ManagePetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('반려동물 관리'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<PetProvider>(
          builder: (context, petProvider, child) {
            debugPrint(
              'Consumer 빌더 호출, isLoading: ${petProvider.isLoading}, pets: ${petProvider.pets}',
            );

            if (petProvider.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return ListView(
              children: [
                Text(
                  '반려동물 정보',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                if (petProvider.pets.isEmpty) Text('등록된 반려동물이 없습니다'),
                if (petProvider.pets.isNotEmpty) buildPetList(petProvider),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    showAddPetDialog(context, petProvider);
                  },
                  child: Text('반려동물 추가'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // 반려동물 추가 다이얼로그
  void showAddPetDialog(BuildContext context, PetProvider petProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('새 반려동물 추가'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: '이름'),
                  onChanged: (value) => petProvider.updatePetName(value),
                ),
                SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(labelText: '품종'),
                  onChanged: (value) => petProvider.updatePetBreed(value),
                ),
                SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    labelText: '나이(개월)',
                    errorText: petProvider.isPetAgeNum ? null : '유효한 숫자를 입력하세요',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => petProvider.updatePetAgeMonth(value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                petProvider.cancelEdit();
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                petProvider.addPetToFirestore(
                  auth.FirebaseAuth.instance.currentUser!.uid,
                );
                Navigator.of(context).pop();
              },
              child: Text('저장'),
            ),
          ],
        );
      },
    );
  }
}
