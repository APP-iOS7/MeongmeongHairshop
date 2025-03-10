import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import '../models/salon.dart';

class NaverApiService {
  static const String clientId = 'M9eZROGKhyCts939lvwq';
  static const String clientSecret = '5NiRFDHjvb';

  static Future<List<Salon>> fetchSalons(String query, double latitude, double longitude) async {
    // 위치 기반 검색을 위한 지역명 추출
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    String location = placemarks.isNotEmpty ? placemarks.first.locality ?? '' : '';

    // 지역명을 포함한 검색
    http.Response response = await _fetchPlaceWithLocation(query, location);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      // fallback: 지역명이 있을 때 결과가 없으면 재요청 (지역명 없이)
      if (data['items'] == null || (data['items'] as List).isEmpty) {
        response = await _fetchPlaceWithLocation(query);
        if (response.statusCode == 200) {
          data = json.decode(response.body);
        } else {
          throw Exception('API 호출 실패: ${response.statusCode}');
        }
      }
      final List<dynamic> items = data['items'] ?? [];
      try {
        return items.map((json) => Salon.fromJson(json)).toList();
      } catch (e) {
        print('데이터 변환 오류: $e');
        return [];
      }
    } else {
      throw Exception('API 호출 실패: ${response.statusCode}');
    }
  }

  static Future<http.Response> _fetchPlaceWithLocation(String query, [String location = '']) async {
    final encodedQuery = Uri.encodeComponent('$query $location');
    final url = Uri.parse(
      'https://openapi.naver.com/v1/search/local.json?query=$encodedQuery&display=5',
    );
    print('API 요청: $url');

    final response = await http.get(
      url,
      headers: {
        'X-Naver-Client-Id': clientId,
        'X-Naver-Client-Secret': clientSecret,
      },
    );
    return response;
  }
}
