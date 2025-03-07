import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../viewmodels/login_viewmodel.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('로그인')),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildEmailField(userProvider),

            _buildPasswordField(userProvider),

            SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    signIn(context);
                  },
                  child: Text('로그인'),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup/user');
              },
              child: Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField(UserProvider userProvider) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return TextField(
          decoration: InputDecoration(labelText: '이메일'),
          onChanged: (value) {
            userProvider.updateEmail(value);
          },
        );
      },
    );
  }

  Widget _buildPasswordField(UserProvider userProvider) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return TextField(
          obscureText: true,
          decoration: InputDecoration(labelText: '비밀번호'),
          onChanged: (value) {
            userProvider.updatePassword(value);
          },
        );
      },
    );
  }
}
