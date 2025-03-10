import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import '../models/salon.dart';
import '../viewmodels/map_viewmodel.dart';

class MapProvider extends ChangeNotifier {
  final MapViewModel _viewModel = MapViewModel();

  List<Salon> get salons => _viewModel.salons;
  bool get isLoading => _viewModel.isLoading;
  set isLoading(bool value) {
    _viewModel.isLoading = value;
    notifyListeners();
  }

  Position? get currentPosition => _viewModel.currentPosition;
  NaverMapController? get mapController => _viewModel.mapController;

  // 지도 컨트롤러 설정
  void setMapController(NaverMapController controller) {
    _viewModel.mapController = controller;
    notifyListeners();
  }

  Future<void> initialize() async {
    await _viewModel.initialize();
    notifyListeners();
  }

  Future<void> fetchPetSalonData(String query) async {
    isLoading = true;
    notifyListeners();

    await _viewModel.fetchPetSalonData(query);

    isLoading = false;
    notifyListeners();
  }

  Future<void> openLink(Salon salon) async {
    isLoading = true;
    notifyListeners();

    await _viewModel.openLink(salon);

    isLoading = false;
    notifyListeners();
  }

  // 현재 위치 업데이트 (필요 시)
  Future<void> updateCurrentPosition() async {
    await _viewModel.fetchCurrentPosition();
    notifyListeners();
  }
}
