// providers/map_provider.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../models/salon.dart';

class MapProvider with ChangeNotifier {
  late NaverMapController mapController;
  List<Salon> _salons = [];
  List<Salon> get salons => _salons;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Position? currentPosition;

  /// 초기화 시 현재 위치를 가져옵니다.
  void init() {
    fetchCurrentPosition();
  }

  /// 네이버 로컬 API 호출하여 살롱 검색
  Future<List<Salon>> fetchSalons(String query, NCameraPosition position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.target.latitude,
      position.target.longitude,
    );
    String location = placemarks.isNotEmpty ? placemarks.first.locality ?? '' : '';

    http.Response response = await fetchPlaceWithLocation(query, location);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['items'] == null || data['items'].isEmpty) {
        // 지역명을 포함한 검색 결과가 없으면 지역정보 없이 재요청
        response = await fetchPlaceWithLocation(query);
        if (response.statusCode == 200) {
          data = json.decode(response.body);
        } else {
          print('API 호출 실패: ${response.statusCode}');
          return [];
        }
      }
      final List<dynamic> places = data['items'] ?? [];

      try {
        return places.map((place) {
          return Salon(
            title: place['title']
                    ?.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '') ??
                '',
            link: place['link'] ?? '',
            category: place['category'] ?? '',
            description: place['description'] ?? '',
            telephone: place['telephone'] ?? '',
            address: place['address'] ?? '',
            roadAddress: place['roadAddress'] ?? '',
            // mapx, mapy 값은 API 반환값의 단위를 고려하여 변환
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

  /// 링크 열기
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
    }).catchError((e) {
      print('위치 가져오기 오류: $e');
    });
  }
}
