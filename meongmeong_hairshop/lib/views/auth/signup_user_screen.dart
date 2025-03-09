import 'package:flutter/material.dart';
import 'package:meongmeong_hairshop/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/signup_viewmodel.dart';

class SignupUserScreen extends StatelessWidget {
  SignupUserScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('회원가입 - 사용자 정보')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                '회원 정보',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),

              _buildEmailField(context),

              _buildPasswordField(context),

              _buildConfirmPasswordField(context),

              _buildUsernameField(context),

              _buildPhoneField(context),

              SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  if (validateUserInfo(context, _formKey)) {
                    Navigator.pushNamed(context, '/signup/pet');
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text('다음', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        return TextFormField(
          controller: _emailController,
          decoration: InputDecoration(labelText: '이메일'),
          validator: (value) {
            if (value?.isEmpty ?? true) return '이메일을 입력해주세요';
            if (!value!.contains('@') || !value.contains('.'))
              return '올바른 이메일 형식이 아닙니다';
            return null;
          },
          onChanged: (value) => userProvider.updateEmail(value),
        );
      },
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        return TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(labelText: '비밀번호'),
          obscureText: true,
          validator: (value) {
            if (value?.isEmpty ?? true) return '패스워드를 입력해주세요';
            if (value!.length < 6) return '비밀번호는 최소 6자 이상이어야 합니다';
            return null;
          },
          onChanged: (value) => userProvider.updatePassword(value),
        );
      },
    );
  }

  Widget _buildConfirmPasswordField(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        return TextFormField(
          controller: _confirmPasswordController,
          decoration: InputDecoration(
            labelText: '비밀번호 확인',
            errorText: userProvider.passwordMatch ? null : '비밀번호가 일치하지 않습니다.',
          ),
          obscureText: true,
          validator: (value) => value?.isEmpty ?? true ? '패스워드를 확인해주세요' : null,
          onChanged: (value) => userProvider.updateConfirmPassword(value),
        );
      },
    );
  }

  Widget _buildUsernameField(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        return TextFormField(
          controller: _userNameController,
          decoration: InputDecoration(labelText: '닉네임'),
          validator: (value) => value?.isEmpty ?? true ? '닉네임을 입력해주세요' : null,
          onChanged: (value) => userProvider.updateUsername(value),
        );
      },
    );
  }

  Widget _buildPhoneField(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        return TextFormField(
          controller: _phoneNumberController,
          decoration: InputDecoration(labelText: '전화번호'),
          keyboardType: TextInputType.number,
          validator: (value) => value?.isEmpty ?? true ? '전화번호를 입력해주세요' : null,
          onChanged: (value) => userProvider.updatePhoneNumber(value),
        );
      },
    );
  }
}
