import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/pet.dart';

class PetProvider with ChangeNotifier {
  List<Pet> _pets = [];
  Pet _currentPet = Pet(name: '', breed: '', ageMonths: 0);

  bool _isPetAgeNum = true;
  bool _isLoading = false;

  List<Pet> get pets => _pets;
  Pet get currentPet => _currentPet; // 사용자가 편집중인 펫 인스턴스를 구분하기 위함
  bool get isPetAgeNum => _isPetAgeNum;
  bool get isLoading => _isLoading;

  void updatePetName(String name) {
    _currentPet.name = name;
    notifyListeners();
  }

  void updatePetBreed(String breed) {
    _currentPet.breed = breed;
    notifyListeners();
  }

  void updatePetAgeMonth(String ageMonth) {
    _checkAgeValue(ageMonth);
    if (_isPetAgeNum) {
      _currentPet.ageMonths = int.parse(ageMonth);
    }
    notifyListeners();
  }

  void _checkAgeValue(String input) {
    final age = int.tryParse(input);
    if (age == null || age <= 0) {
      _isPetAgeNum = false;
    } else {
      _isPetAgeNum = true;
    }
  }

  void addPet() {
    if (_currentPet.name.isNotEmpty &&
        _currentPet.breed.isNotEmpty &&
        _currentPet.ageMonths > 0) {
      _pets.add(
        Pet(
          name: _currentPet.name,
          breed: _currentPet.breed,
          ageMonths: _currentPet.ageMonths,
        ),
      );

      _currentPet = Pet(name: '', breed: '', ageMonths: 0);
      notifyListeners();
    }
  }

  void removePet(int index) {
    if (index >= 0 && index < _pets.length) {
      _pets.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> savePetsToFirestore(String userId) async {
    try {
      final userDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId);
      final batch = FirebaseFirestore.instance.batch();

      for (var pet in _pets) {
        final petDocRef = userDocRef.collection('pets').doc();
        batch.set(petDocRef, pet.toFirestore());
      }

      await batch.commit();
    } catch (e) {
      debugPrint('Error saving pets to Firestore: $e');
    }
  }

  Future<void> fetchPetsFromFirestore(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _pets = [];

      final petsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('pets')
          .orderBy('createdAt', descending: false); // 생성 시간순 정렬

      final querySnapshot = await petsCollection.get();

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        _pets.add(
          Pet(
            id: doc.id,
            name: data['name'] ?? '',
            breed: data['breed'] ?? '',
            ageMonths: data['ageMonths'] ?? 0,
          ),
        );
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      print('Error fetching pets from Firestore: $e');
      notifyListeners();
      throw e;
    }
  }

  // 회원가입 완료 후 모든 상태 리셋
  void resetAll() {
    _pets = [];
    _currentPet = Pet(name: '', breed: '', ageMonths: 0);
    _isPetAgeNum = true;
    notifyListeners();
  }
}
