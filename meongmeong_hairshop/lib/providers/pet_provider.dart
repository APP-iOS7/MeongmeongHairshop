import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/pet.dart';

class PetProvider with ChangeNotifier {
  List<Pet> _pets = [];
  Pet _currentPet = Pet(name: '', breed: '', ageMonths: 0);

  bool _isPetAgeNum = true;
  bool _isLoading = false;
  // 편집모드 플래그
  bool _isEditMode = false;
  int _editingIndex = -1;

  List<Pet> get pets => _pets;
  Pet get currentPet => _currentPet; // 사용자가 편집중인 펫 인스턴스를 구분하기 위함
  bool get isPetAgeNum => _isPetAgeNum;
  bool get isLoading => _isLoading;
  bool get isEditMode => _isEditMode;
  int get editingIndex => _editingIndex;

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

  void editPet(int index) {
    if (index >= 0 && index < _pets.length) {
      _currentPet = Pet(
        id: _pets[index].id,
        name: _pets[index].name,
        breed: _pets[index].breed,
        ageMonths: _pets[index].ageMonths,
      );
      _isEditMode = true;
      _editingIndex = index;
      notifyListeners();
    }
  }

  void updatePet() {
    if (_editingIndex >= 0 &&
        _editingIndex < _pets.length &&
        _currentPet.name.isNotEmpty &&
        _currentPet.breed.isNotEmpty &&
        _currentPet.ageMonths > 0) {
      _pets[_editingIndex] = Pet(
        id: _currentPet.id,
        name: _currentPet.name,
        breed: _currentPet.breed,
        ageMonths: _currentPet.ageMonths,
      );

      // 편집 모드 종료 및 초기화
      _isEditMode = false;
      _editingIndex = -1;
      _currentPet = Pet(name: '', breed: '', ageMonths: 0);
      notifyListeners();
    }
  }

  void cancelEdit() {
    _isEditMode = false;
    _editingIndex = -1;
    _currentPet = Pet(name: '', breed: '', ageMonths: 0);
    notifyListeners();
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
        pet.id = petDocRef.id;

        batch.set(petDocRef, {
          ...pet.toFirestore(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();

      notifyListeners();
    } catch (e) {
      debugPrint('Error saving pets to Firestore: $e');
    }
  }

  // 앱 실행 시 데이터를 불러오도록 처리
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
        _pets.add(Pet.fromFirestore(data, doc.id));
        debugPrint(doc.id);
        debugPrint(_pets.first.name);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      debugPrint('Error fetching pets from Firestore: $e');
      notifyListeners();
    }
  }

  Future<void> addPetToFirestore(String userId) async {
    try {
      final userDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId);
      final petDocRef = userDocRef.collection('pets').doc();

      await petDocRef.set({
        'id': petDocRef.id,
        'name': _currentPet.name,
        'breed': _currentPet.breed,
        'ageMonths': _currentPet.ageMonths,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 로컬 프로바이더에도 반영
      _pets.add(
        Pet(
          id: petDocRef.id,
          name: _currentPet.name,
          breed: _currentPet.breed,
          ageMonths: _currentPet.ageMonths,
        ),
      );

      _currentPet = Pet(name: '', breed: '', ageMonths: 0);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding pet to Firestore: $e');
    }
  }

  Future<void> deletePetFromFirestore(String userId, int index) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('pets')
          .doc(pets[index].id)
          .delete();
    } catch (e) {
      debugPrint('Error deleting pet from Firestore: $e');
    }
  }

  Future<void> updatePetInFirestore(String userId, String petId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('pets')
          .doc(petId)
          .update(_currentPet.toFirestore());
    } catch (e) {
      debugPrint('Error updating pet in Firestore: $e');
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
