import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/salon.dart';
import '../services/location_service.dart';
import '../services/naver_api_service.dart';

class MapViewModel {
  late NaverMapController mapController;
  List<Salon> salons = [];
  bool isLoading = false;
  Position? currentPosition;

  /// 초기화 시 현재 위치 가져오기
  Future<void> initialize() async {
    await fetchCurrentPosition();
  }

  /// 현재 위치 가져오기
  Future<void> fetchCurrentPosition() async {
    try {
      currentPosition = await LocationService.getCurrentPosition();
    } catch (e) {
      print('위치 가져오기 오류: $e');
    }
  }

  /// 네이버 로컬 API를 통해 살롱 검색
  Future<List<Salon>> fetchSalons(String query) async {
    final cameraPosition = mapController.nowCameraPosition;
    return await NaverApiService.fetchSalons(
      query,
      cameraPosition.target.latitude,
      cameraPosition.target.longitude,
    );
  }

  /// 살롱 데이터 검색 및 업데이트
  Future<void> fetchPetSalonData(String query) async {
    try {
      salons = await fetchSalons(query);
      print('펫미용실 리스트: $salons');
    } catch (e) {
      print('검색 오류: $e');
      salons = [];
    }
  }

  /// 외부 링크 열기
  Future<void> openLink(Salon salon) async {
    final Uri url = Uri.parse(salon.link);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch ${salon.link}');
    }
  }
}
