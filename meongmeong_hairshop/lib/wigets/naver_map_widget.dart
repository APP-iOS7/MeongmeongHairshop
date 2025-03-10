// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_naver_map/flutter_naver_map.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';

// import '../viewmodels/map_view_model.dart';

// class NaverMapWidget extends StatefulWidget {
//   final NaverMapController mapController;
//   final NLatLng markerPosition;
//   const NaverMapWidget({
//     super.key,
//     required this.mapController,
//     required this.markerPosition,
//   });


//   @override
//   _NaverMapWidget createState() => _NaverMapWidget();
// }

// class _NaverMapWidget extends State<NaverMapWidget> {
//   final Completer<NaverMapController> _controller = Completer();
//   OverlayEntry? _lottieOverlay;
//   late NaverMapController _mapController;
  
//   Offset? _markerScreenPosition;
//   late NMarker _marker;

//   @override
//   void initState() {
//     super.initState();
//     _mapController = widget.mapController;
//     _addNMarker(); // 네이버 지도 마커 추가

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _updateLottiePosition(); // 초기 Lottie 위치 설정
//     });
//   }

//   /// 네이버 지도 마커(NMarker) 추가
//   void _addNMarker() {
//     _marker = NMarker(
//       id: "lottie_marker",
//       position: widget.markerPosition,
//       icon: NOverlayImage.fromAssetImage("assets/marker_icon.png"), // 기본 마커 아이콘
//       size: const Size(60, 60),
//     );

//     // ✅ 마커 클릭 시 애니메이션 실행
//     _marker.setOnTapListener((overlay) {
//       _showLottieMarker();
//     });

//     widget.mapController.addOverlay(_marker);
//   }

//   /// 위도·경도를 픽셀 좌표로 변환하고 Overlay 업데이트
//   Future<void> _updateLottiePosition() async {
//     final screenPos = await widget.mapController.latLngToScreenLocation(widget.markerPosition);

//     if (!mounted) return;

//     setState(() {
//       _markerScreenPosition = Offset(screenPos.x - 50, screenPos.y - 50); // 중앙 정렬
//     });

//     _showLottieMarker();
//   }

//   /// Lottie 애니메이션을 Overlay에 추가
//   void _showLottieMarker() {
//     if (_markerScreenPosition == null) return;

//     _lottieOverlay?.remove(); // 기존 Overlay 제거

//     _lottieOverlay = OverlayEntry(
//       builder: (context) => Positioned(
//         top: _markerScreenPosition!.dy,
//         left: _markerScreenPosition!.dx,
//         child: Lottie.asset(
//           'assets/loading.json', // Lottie 애니메이션
//           width: 100,
//           height: 100,
//           fit: BoxFit.cover,
//         ),
//       ),
//     );

//     Overlay.of(context).insert(_lottieOverlay!);
//   }

//   @override
//   void dispose() {
//     _lottieOverlay?.remove();
//     widget.mapController.deleteOverlay(_marker); // ✅ 마커 제거
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
    
//     // return NaverMap(
//     //   onMapCreated: (controller) {
//     //     widget.mapController.setOnCameraChangeListener((position, reason) {
//     //       _updateLottiePosition(); // ✅ 지도 이동 시 애니메이션 위치 업데이트
//     //     });
//     //   },
//     // );
// final viewModel = context.watch<MapViewModel>();
//     return NaverMap(
//                       options: NaverMapViewOptions(locationButtonEnable: true),
//                       onMapReady: (controller) {
//                         _mapController = controller;
//                         viewModel.mapController = controller;
//                         if (!_controller.isCompleted) {
//                           _controller.complete(controller);
//                         }
//                       },
//                       onCameraIdle: () {
//                         if (!_suppressApiOnCameraIdle) {
//                           SchedulerBinding.instance.addPostFrameCallback((
//                             _,
//                           ) async {
//                             await viewModel.fetchPetSalonData('반려동물미용');
//                             _mapController.clearOverlays();
//                             for (var salon in viewModel.salons) {
//                               NMarker marker = NMarker(
//                                 id: salon.title,
//                                 position: NLatLng(salon.mapy, salon.mapx),
//                               );
//                               _mapController.addOverlay(marker);
//                               // 마커 탭 시 모달을 애니메이션과 함께 오버레이로 띄웁니다.
//                               marker.setOnTapListener((NMarker marker) {
//                                 setState(() {
//                                   _isMarkerModalOpen = true;
//                                   _selectedSalon = salon;
//                                 });
//                                 _modalController.forward();
//                               });
//                             }
//                           });
//                         } else {
//                           _suppressApiOnCameraIdle = false;
//                         }
//                       },
//                       // 지도 이동(제스처) 시 모달 닫기 및 검색 패널 닫기
//                       onCameraChange: (reason, animated) {
//                         if (_isMarkerModalOpen &&
//                             _modalController.status !=
//                                 AnimationStatus.reverse) {
//                           _closeMarkerModal();
//                         }
//                         if (_isSearchResultsVisible &&
//                             !_suppressApiOnCameraIdle &&
//                             _panelController.status !=
//                                 AnimationStatus.reverse) {
//                           _dismissSearchResults();
//                         }
//                       },
//                     ),
//   }
// }
