import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meongmeong_hairshop/providers/user_provider.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _petNameController = TextEditingController();
  final TextEditingController _petBreedController = TextEditingController();
  final TextEditingController _petAgeMonthController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('회원가입')),
      body: Padding(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('회원 정보'),
              Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ' 이메일을 입력해주세요';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: '이메일'),
                    onChanged: (value) {
                      userProvider.updateEmail(value);
                    },
                  );
                },
              ),
              Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '패스워드를 입력해주세요';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(labelText: '비밀번호'),
                    onChanged: (value) {
                      userProvider.updatePassword(value);
                    },
                  );
                },
              ),
              Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return TextFormField(
                    controller: _confirmPasswordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '패스워드를 확인해주세요';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: '비밀번호 확인',
                      errorText:
                          userProvider.passwordMatch
                              ? null
                              : '비밀번호가 일치하지 않습니다.',
                    ),
                    onChanged: (value) {
                      userProvider.updateConfirmPassword(value);
                    },
                  );
                },
              ),
              Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return TextFormField(
                    controller: _userNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ' 닉네임을 입력해주세요';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: '닉네임'),
                    onChanged: (value) {
                      userProvider.updateUsername(value);
                    },
                  );
                },
              ),
              Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return TextFormField(
                    controller: _phoneNumberController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ' 전화번호를 입력해주세요';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: '전화번호'),
                    onChanged: (value) {
                      userProvider.updatePhoneNumber(value);
                    },
                  );
                },
              ),
              SizedBox(height: 40),
              Text('반려동물 정보'),
              Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return TextFormField(
                    controller: _petNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '반려동물 이름을 입력해주세요';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: '반려동물 이름'),
                    onChanged: (value) {
                      userProvider.updatePetName(value);
                    },
                  );
                },
              ),
              Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return TextFormField(
                    controller: _petBreedController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '반려동물 품종을 입력해주세요';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: '품종'),
                    onChanged: (value) {
                      userProvider.updatePetBreed(value);
                    },
                  );
                },
              ),
              Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return TextFormField(
                    controller: _petAgeMonthController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '반려동물 개월 수를 입력해주세요';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: '반려동물 개월 수',
                      errorText:
                          userProvider.isPetAgeNum ? null : '올바른 나이를 입력하세요.',
                    ),
                    onChanged: (value) {
                      userProvider.updatePetAgeMonth(value);
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
                      signUp(context);
                    },
                    child: Text('회원등록'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signUp(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      if (Provider.of<UserProvider>(context, listen: false).passwordMatch &&
          Provider.of<UserProvider>(context, listen: false).isPetAgeNum) {
        try {
          print(
            'email = ${_emailController.text}, password: ${_passwordController.text}',
          );
          final credential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text,
              );
          Navigator.pushNamed(context, '/login');
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            print('The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            print('The account already exists for that email.');
          }
        } catch (e) {
          print(e);
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("입력한 정보를 다시 확인해주세요.")));
      }
    }
  }
}
