class Pet {
  String name;
  String breed;
  int ageMonths;

  Pet({required this.name, required this.breed, required this.ageMonths});

  Map<String, dynamic> toFirestore() {
    return {'name': name, 'breed': breed, 'ageMonths': ageMonths};
  }

  factory Pet.fromFirestore(Map<String, dynamic> json) {
    return Pet(
      name: json['name'],
      breed: json['breed'],
      ageMonths: (json['ageMonths'] as num).toInt(),
    );
  }
}
