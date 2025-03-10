import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import '../config/app_styles.dart';
import '../models/pet.dart';
import '../providers/pet_provider.dart';

Widget buildPetList(PetProvider petProvider) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '등록된 반려동물',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      SizedBox(height: 8),
      ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: petProvider.pets.length,
        itemBuilder: (context, index) {
          Pet pet = petProvider.pets[index];
          return Card(
            margin: EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(
                pet.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${pet.breed}, ${pet.ageMonths}개월',
                style: TextStyle(color: Colors.grey[700]),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: AppColors.primary),
                    onPressed: () {
                      petProvider.editPet(index);
                      _showEditPetDialog(context, petProvider);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.cancel, color: AppColors.textMedium),
                    onPressed: () => petProvider.removePet(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ],
  );
}

void _showEditPetDialog(BuildContext context, PetProvider petProvider) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('반려동물 정보 수정'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: '이름'),
                controller: TextEditingController(
                  text: petProvider.currentPet.name,
                ),
                onChanged: (value) => petProvider.updatePetName(value),
              ),
              SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(labelText: '품종'),
                controller: TextEditingController(
                  text: petProvider.currentPet.breed,
                ),
                onChanged: (value) => petProvider.updatePetBreed(value),
              ),
              SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  labelText: '나이(개월)',
                  errorText: petProvider.isPetAgeNum ? null : '유효한 숫자를 입력하세요',
                ),
                controller: TextEditingController(
                  text: petProvider.currentPet.ageMonths.toString(),
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
            onPressed: () async {
              petProvider.updatePet();

              final currentUser = auth.FirebaseAuth.instance.currentUser;

              if (petProvider.currentPet.id != null &&
                  currentUser!.uid.isNotEmpty) {
                try {
                  await petProvider.updatePetInFirestore(
                    currentUser.uid,
                    petProvider.currentPet.id!,
                  );
                } catch (e) {
                  debugPrint('Error: 반려 동물 조회에 실패했습니다.');
                }
              }
              Navigator.of(context).pop();
            },
            child: Text('저장'),
          ),
        ],
      );
    },
  );
}
