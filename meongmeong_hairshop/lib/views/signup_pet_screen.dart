import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meongmeong_hairshop/config/app_styles.dart';
import 'package:provider/provider.dart';
import '../models/user_pet.dart';
import '../providers/pet_provider.dart';
import '../providers/user_provider.dart';

class SignupPetScreen extends StatelessWidget {
  SignupPetScreen({super.key});

  final TextEditingController _petNameController = TextEditingController();
  final TextEditingController _petBreedController = TextEditingController();
  final TextEditingController _petAgeMonthController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입 - 반려동물 정보'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              '반려동물 정보',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 16),

            if (petProvider.pets.isNotEmpty) _buildPetList(petProvider),

            SizedBox(height: 16),

            _buildPetNameField(petProvider),
            _buildPetBreedField(petProvider),
            _buildPetAgeField(petProvider),

            SizedBox(height: 16),

            _buildAddPetButton(context, petProvider),

            SizedBox(height: 24),

            ElevatedButton(
              onPressed: () => _signUp(context, userProvider, petProvider),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text('회원가입 완료', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  // 반려동물 목록
  Widget _buildPetList(PetProvider petProvider) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        itemCount: petProvider.pets.length,
        itemBuilder: (context, index) {
          UserPet pet = petProvider.pets[index];
          return ListTile(
            title: Text(pet.name),
            subtitle: Text('${pet.breed}, ${pet.ageMonths}개월'),
            trailing: IconButton(
              icon: Icon(Icons.cancel, color: AppColors.textMedium),
              onPressed: () => petProvider.removePet(index),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPetNameField(PetProvider petProvider) {
    return Consumer<PetProvider>(
      builder: (context, petProvider, _) {
        return TextFormField(
          controller: _petNameController,
          decoration: InputDecoration(labelText: '반려동물 이름'),
          onChanged: (value) => petProvider.updatePetName(value),
        );
      },
    );
  }

  Widget _buildPetBreedField(PetProvider petProvider) {
    return Consumer<PetProvider>(
      builder: (context, petProvider, _) {
        return TextFormField(
          controller: _petBreedController,
          decoration: InputDecoration(labelText: '품종'),
          onChanged: (value) => petProvider.updatePetBreed(value),
        );
      },
    );
  }

  Widget _buildPetAgeField(PetProvider petProvider) {
    return Consumer<PetProvider>(
      builder: (context, petProvider, _) {
        return TextFormField(
          controller: _petAgeMonthController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: '반려동물 개월 수',
            errorText: petProvider.isPetAgeNum ? null : '올바른 나이를 입력하세요.',
          ),
          onChanged: (value) => petProvider.updatePetAgeMonth(value),
        );
      },
    );
  }

  Widget _buildAddPetButton(BuildContext context, PetProvider petProvider) {
    return ElevatedButton.icon(
      onPressed: () {
        if (_petNameController.text.isNotEmpty &&
            _petBreedController.text.isNotEmpty &&
            _petAgeMonthController.text.isNotEmpty) {
          petProvider.addPet();

          // 폼 초기화
          _petNameController.clear();
          _petBreedController.clear();
          _petAgeMonthController.clear();
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('반려동물 정보를 모두 입력해주세요')));
        }
      },
      icon: Icon(Icons.pets),
      label: Text('반려동물 추가'),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
    );
  }

  // 회원가입 처리: 뷰모델로 이동해야함
  Future<void> _signUp(
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
}
