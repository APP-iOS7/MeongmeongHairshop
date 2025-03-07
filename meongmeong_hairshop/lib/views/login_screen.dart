import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('로그인')),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                return TextField(
                  decoration: InputDecoration(labelText: '이메일'),
                  onChanged: (value) {
                    userProvider.updateEmail(value);
                  },
                );
              },
            ),
            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                return TextField(
                  obscureText: true,
                  decoration: InputDecoration(labelText: '비밀번호'),
                  onChanged: (value) {
                    userProvider.updatePassword(value);
                  },
                );
              },
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/success');
                  },
                  child: Text('로그인'),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}
