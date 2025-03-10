import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../models/salon.dart';

class MapViewModel with ChangeNotifier {
  late NaverMapController mapController;
  // 살롱 목록
  List<Salon> _salons = [];
  List<Salon> get salons => _salons;

  // 로딩 상태
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // 현재 위치
  Position? currentPosition;

  // 초기화 시, 현재 위치 가져오기
  void init() {
    fetchCurrentPosition();
  }

  /// 네이버 로컬 API 호출하여 살롱 검색
  Future<List<Salon>> fetchSalons(
    String query,
    NCameraPosition position,
  ) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.target.latitude,
      position.target.longitude,
    );
    String location =
        placemarks.isNotEmpty ? placemarks.first.locality ?? '' : '';

    // if (location.isEmpty) {
    //   print("주소를 찾을 수 없습니다.");
    //   return [];
    // }
    // 위치 기반 검색을 위해 지역명 포함
    http.Response response = await fetchPlaceWithLocation(query, location);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data['items']);

      if (data['items'].isEmpty || data['items'] == null) {
        http.Response response = await fetchPlaceWithLocation(query);
        if (response.statusCode == 200) {
          data = json.decode(response.body);
          print(data['items']);
        } else {
          print('API 호출 실패: ${response.statusCode}');
          return [];
        }
      }
      final List<dynamic> places = data['items'] ?? [];

      // Salon 모델 리스트로 변환
      try {
        return places.map((place) {
          return Salon(
            title:
                place['title']?.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '') ??
                '',
            link: place['link'] ?? '',
            category: place['category'] ?? '',
            description: place['description'] ?? '',
            telephone: place['telephone'] ?? '',
            address: place['address'] ?? '',
            roadAddress: place['roadAddress'] ?? '',
            mapx: (double.tryParse(place['mapx'] ?? '') ?? 0) / 10000000,
            mapy: (double.tryParse(place['mapy'] ?? '') ?? 0) / 10000000,
          );
        }).toList();
      } catch (e) {
        print('데이터 변환 오류: $e');
        return [];
      }
    } else {
      print('API 호출 실패: ${response.statusCode}');
      return [];
    }
  }

  Future<http.Response> fetchPlaceWithLocation(String query, [String location = '']) async {
    final encodedQuery = Uri.encodeComponent('$query $location');

    final url = Uri.parse(
      'https://openapi.naver.com/v1/search/local.json?query=$encodedQuery&display=5',
    );

    print('API 요청: $url');

    final response = await http.get(
      url,
      headers: {
        'X-Naver-Client-Id': 'M9eZROGKhyCts939lvwq',
        'X-Naver-Client-Secret': '5NiRFDHjvb',
      },
    );
    return response;
  }

  /// 살롱 데이터 검색
  Future<void> fetchPetSalonData(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      // 네이버 API 호출
      final salonData = await fetchSalons(
        query,
        mapController.nowCameraPosition,
      );
      _salons = salonData;
      print('펫미용실 리스트: $_salons');
    } catch (e) {
      print('검색 오류: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> openLink(Salon salon) async {
    final Uri url = Uri.parse(salon.link);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch ${salon.link}';
    }
  }

  /// 현재 위치 가져오기
  void fetchCurrentPosition() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((position) {
          currentPosition = position;
          notifyListeners();
        })
        .catchError((e) {
          print('위치 가져오기 오류: $e');
        });
  }
}
