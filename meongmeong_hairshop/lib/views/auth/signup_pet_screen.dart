import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/pet_provider.dart';
import '../../providers/user_provider.dart';
import '../../viewmodels/signup_viewmodel.dart';
import '../../widgets/display_pet_list.dart';

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

            if (petProvider.pets.isNotEmpty) buildPetList(petProvider),

            SizedBox(height: 16),

            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '새 반려동물 추가',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    _buildPetNameField(petProvider),
                    _buildPetBreedField(petProvider),
                    _buildPetAgeField(petProvider),
                    SizedBox(height: 16),
                    _buildAddPetButton(context, petProvider),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            ElevatedButton(
              onPressed:
                  () async => await signUp(context, userProvider, petProvider),
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
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
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
      ),
    );
  }
}
