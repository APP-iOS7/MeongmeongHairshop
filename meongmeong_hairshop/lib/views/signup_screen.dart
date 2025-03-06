import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/signup_viewmodel.dart';
import '../models/user.dart';
import '../models/pet.dart';
import '../models/salon.dart';
import '../models/reservation.dart';

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignupViewModel(),
      child: Scaffold(
        appBar: AppBar(title: Text('회원가입')),
        body: Consumer<SignupViewModel>(
          builder: (context, viewModel, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // ...
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}