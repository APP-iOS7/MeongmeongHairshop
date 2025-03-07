import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../viewmodels/map_view_model.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late NaverMapController _mapController;
  StreamSubscription<Position>? _positionStream;
  
  @override
  void initState() {
    super.initState();
    Provider.of<MapViewModel>(context, listen: false).init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('애견 미용실 지도')),
      body: Consumer<MapViewModel>(
        builder: (context, viewModel, child) {
          return NaverMap(
            onMapReady: (controller) {
              _mapController = controller;
              if (viewModel.currentPosition != null) {
                _mapController.updateCamera(
                  NCameraUpdate.scrollAndZoomTo(
                    target: NLatLng(
                      viewModel.currentPosition!.latitude,
                      viewModel.currentPosition!.longitude,
                    ),
                  ),
                );
                _addMarkers(viewModel.markers.toSet());
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_positionStream == null) {
            _startLocationUpdates();
          } else {
            _stopLocationUpdates();
          }
        },
        child: Icon(Icons.my_location),
      ),
    );
  }

  void _addMarkers(Set<NMarker> markers) {
    _mapController.addOverlayAll(markers); // 마커 추가
  }

  void _startLocationUpdates() {
    _positionStream = Geolocator.getPositionStream().listen((Position position) {
      // 위치 정보 업데이트 처리
      _updateCameraPosition(position);
    });
  }

  void _stopLocationUpdates() {
    if (_positionStream != null) {
      _positionStream!.cancel();
      _positionStream = null; // 스트림 구독 해제 후 null로 설정
    }
  }

  void _updateCameraPosition(Position position) {
    _mapController.updateCamera(
      NCameraUpdate.scrollAndZoomTo(
        target: NLatLng(position.latitude, position.longitude),
        zoom: 15,
      ),
    );
  }
}
