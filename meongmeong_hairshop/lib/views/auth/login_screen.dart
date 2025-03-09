import 'package:flutter/material.dart';
import '../../viewmodels/login_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('로그인')),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: '이메일'),
            ),

            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: '비밀번호'),
            ),

            SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    String email = _emailController.text.trim();
                    String password = _passwordController.text;
                    signIn(context, email, password);
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
}
