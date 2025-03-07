import 'package:flutter/material.dart';
import '../models/salon.dart';

class SalonListViewModel with ChangeNotifier {
  List<Salon> _salons = [];

  List<Salon> get salons => _salons;

  // 미용실 목록 가져오는 로직 (예시)
  Future<void> fetchSalons() async {
    // API 또는 데이터베이스에서 미용실 목록 가져오기
    _salons = [
      Salon(name: '멍멍 미용실', operatingHours: '10:00 - 11:00', address: '서울시 강남구', telephone: '02-1234-5678', mapx: '127.1234', mapy: '37.1234', link: 'https://naver.com'),
      Salon(name: '야옹 미용실', operatingHours: '20:00 - 21:00', address: '서울시 서초구', telephone: '02-9876-5432', mapx: '127.5678', mapy: '37.5678', link: 'https://google.com'),
      // ...
    ];
    notifyListeners();
  }
}