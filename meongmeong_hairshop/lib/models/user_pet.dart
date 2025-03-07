class UserPet {
  String name;
  String breed;
  int ageMonths;

  UserPet({required this.name, required this.breed, required this.ageMonths});

  Map<String, dynamic> toJson() {
    return {'name': name, 'breed': breed, 'ageMonths': ageMonths};
  }

  factory UserPet.fromJson(Map<String, dynamic> json) {
    return UserPet(
      name: json['name'],
      breed: json['breed'],
      ageMonths: (json['ageMonths'] as num).toInt(),
    );
  }
}
