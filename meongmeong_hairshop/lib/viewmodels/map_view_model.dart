import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../models/salon.dart';

class MapViewModel with ChangeNotifier {
  List<NMarker> markers = [];
  List<Salon> salons = [];
  Position? currentPosition;

  Future<void> init() async {
    await _getCurrentLocation();
    await _fetchPetSalonData();
  }

  Future<void> _getCurrentLocation() async {
    try {
      currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      notifyListeners();
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _fetchPetSalonData() async {
    if (currentPosition == null) return;

    final url = Uri.parse(
      'https://openapi.naver.com/v1/search/local.json?query=애견미용실&display=20&latitude=${currentPosition!.latitude}&longitude=${currentPosition!.longitude}',
    );
    final headers = {
      'X-Naver-Client-Id': 'yd79jdvpdg',
      'X-Naver-Client-Secret': 'lgryqtHmN5wwoHgoar6qYyx0RnaNE2IljYpIGSFX',
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        salons = (data['items'] as List).map((item) => Salon.fromJson(item)).toList();
        _updateMarkers();
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _updateMarkers() {
    markers = salons.map((salon) {
      return NMarker(
        id: salon.name,
        position: NLatLng(
          double.parse(salon.mapy) / 10000000,
          double.parse(salon.mapx) / 10000000,
        ),
        // 수정해야함
        // onTap: (marker, iconSize) {
        //   _showSalonDetails(salon);
        // },
      );
    }).toList();
    notifyListeners();
  }

  void _showSalonDetails(Salon salon) {
    // 모달 표시 로직
    // ...
  }
}