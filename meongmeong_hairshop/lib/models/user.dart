import 'pet.dart';

class User {
  String email;
  String password;
  String username;
  String phoneNumber;
  Pet pet;

  User({
    required this.email,
    required this.password,
    required this.username,
    required this.phoneNumber,
    required this.pet,
  });
}
