class Pet {
  String? id; // Firestore 펫 문서 ID
  String name;
  String breed;
  int ageMonths;

  Pet({
    this.id,
    required this.name,
    required this.breed,
    required this.ageMonths,
  });

  Map<String, dynamic> toFirestore() {
    return {'id': id, 'name': name, 'breed': breed, 'ageMonths': ageMonths};
  }

  factory Pet.fromFirestore(Map<String, dynamic> json, String documentId) {
    return Pet(
      id: documentId,
      name: json['name'],
      breed: json['breed'],
      ageMonths: (json['ageMonths']),
    );
  }
}
