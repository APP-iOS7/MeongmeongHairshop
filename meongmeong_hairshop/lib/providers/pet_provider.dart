import 'package:flutter/foundation.dart';
import '../models/pet.dart';

class PetProvider with ChangeNotifier {
  List<Pet> _pets = [];
  Pet _currentPet = Pet(name: '', breed: '', ageMonths: 0);

  bool _isPetAgeNum = true;

  List<Pet> get pets => _pets;
  Pet get currentPet => _currentPet; // 사용자가 편집중인 펫 인스턴스를 구분하기 위함
  bool get isPetAgeNum => _isPetAgeNum;

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
}
