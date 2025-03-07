class User {
  String email;
  String username;
  String phoneNumber;

  User({
    required this.email,
    required this.username,
    required this.phoneNumber,
  });

  Map<String, dynamic> toFirestore() {
    return {'email': email, 'username': username, 'phoneNumber': phoneNumber};
  }

  factory User.fromFirestore(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      username: json['username'],
      phoneNumber: (json['phoneNumber']),
    );
  }
}
