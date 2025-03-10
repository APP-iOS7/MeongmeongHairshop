import 'package:flutter/material.dart';
import 'package:meongmeong_hairshop/providers/user_provider.dart';
import 'package:meongmeong_hairshop/viewmodels/reservation_viewmodel.dart';
import 'package:provider/provider.dart';

class EditUserScreen extends StatefulWidget {
  const EditUserScreen({super.key});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUserfromFirebase();
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('회원 정보 수정')),
      body:
          userProvider.isLoading ||
                  userProvider.error != null && userProvider.user == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: '이름',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator:
                            (value) =>
                                value?.isEmpty ?? true ? '이름을 입력해주세요' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneNumberController,
                        decoration: const InputDecoration(
                          labelText: '전화번호',
                          prefixIcon: Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.phone,
                        validator:
                            (value) =>
                                value?.isEmpty ?? true ? '전화번호를 입력해주세요' : null,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed:
                            userProvider.isLoading ? null : _updateProfile,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child:
                            userProvider.isLoading
                                ? const CircularProgressIndicator()
                                : const Text('저장하기'),
                      ),
                      if (userProvider.error != null &&
                          userProvider.user != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            userProvider.error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
    );
  }

  Future<void> _updateProfile() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    ReservationFirestoreService _firestoreService = ReservationFirestoreService();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 이름을 바꾸면 예약정보에서의 이름도 바꿔줘야함
    _firestoreService.updateReservationByUserName(
      userProvider.user!.username,
      _phoneNumberController.text.trim(),
      _usernameController.text.trim(),
    );

    final result = await userProvider.updateUserData(
      username: _usernameController.text.trim(),
      phoneNumber: _phoneNumberController.text.trim(),
    );

    if (result && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('회원 정보가 성공적으로 업데이트되었습니다')));
      Navigator.of(context).pop();
    }
  }
}
