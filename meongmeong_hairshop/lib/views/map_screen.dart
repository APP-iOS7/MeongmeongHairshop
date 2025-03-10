import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:meongmeong_hairshop/models/salon.dart';
import 'package:provider/provider.dart';
import 'package:flutter/animation.dart';

import '../viewmodels/map_view_model.dart';
import '../wigets/naver_map_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with SingleTickerProviderStateMixin {
  // 네이버 맵 컨트롤러
  final Completer<NaverMapController> _controller = Completer();
  late NaverMapController _mapController;
  String searchString = '';

  // 패널 애니메이션 관련 변수
  late AnimationController _panelController;
  late Animation<Offset> _slideAnimation;
  bool _isSearchResultsVisible = false;
  bool _shouldShowPanel = false; // 새 검색 시에만 true로 세팅

  // 리스트 아이템 탭 후, API 재요청 방지를 위한 플래그
  bool _suppressApiOnCameraIdle = false;

  @override
  void initState() {
    super.initState();
    _panelController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      value: 0.0, // 시작은 숨긴 상태
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1), // 화면 아래쪽 (숨김)
      end: Offset(0, 0),   // 제자리 (완전히 열린 상태)
    ).animate(_panelController);
  }

  @override
  void dispose() {
    _panelController.dispose();
    super.dispose();
  }

  void _dismissSearchResults() {
    // 패널 닫기 애니메이션을 시작합니다.
    _panelController.reverse().then((_) {
      setState(() {
        _isSearchResultsVisible = false;
        _shouldShowPanel = false; // 닫힐 때 플래그 초기화
      });
    });
  }

  void _handleVerticalDragUpdate(DragUpdateDetails details, double panelHeight) {
    double fractionDragged = details.primaryDelta! / panelHeight;
    _panelController.value = (_panelController.value - fractionDragged).clamp(0.0, 1.0);
  }

  void _handleVerticalDragEnd(DragEndDetails details) {
    // 아래로 드래그한 속도 혹은 패널 상태에 따라 닫기 결정
    if (_panelController.value < 0.8 || details.primaryVelocity! > 300) {
      _dismissSearchResults();
    } else {
      _panelController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ViewModel 접근
    final viewModel = context.watch<MapViewModel>();

    // 새 검색 요청(_shouldShowPanel true)이고 결과가 있으면 패널 열기
    if (viewModel.salons.isNotEmpty && !_isSearchResultsVisible && _shouldShowPanel) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _isSearchResultsVisible = true;
        });
        _panelController.forward();
      });
    }

    // 현재 위치가 있으면 해당 좌표, 없으면 기본 좌표(서울 시청 근처)
    final initialPosition = viewModel.currentPosition != null
        ? NLatLng(
            viewModel.currentPosition!.latitude,
            viewModel.currentPosition!.longitude,
          )
        : const NLatLng(37.5666102, 126.9783881);

    return Scaffold(
      appBar: AppBar(title: const Text('펫미용실 검색')),
      body: Stack(
        children: [
          // 기본 화면: 검색 입력부와 지도 영역
          Column(
            children: [
              // 검색 입력부
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onSubmitted: (query) {
                          setState(() {
                            _shouldShowPanel = true; // 새 검색 시 패널 열림 플래그 세팅
                          });
                          viewModel.fetchPetSalonData(query);
                        },
                        decoration: const InputDecoration(
                          labelText: '검색어를 입력해주세요.',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          searchString = value;
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          _shouldShowPanel = true; // 새 검색 시 패널 열림 플래그 세팅
                        });
                        viewModel.fetchPetSalonData(searchString);
                      },
                    ),
                  ],
                ),
              ),
              // 지도 영역
              Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    NaverMap(
                      options: NaverMapViewOptions(locationButtonEnable: true),
                      onMapReady: (controller) {
                        _mapController = controller;
                        viewModel.mapController = controller;
                        if (!_controller.isCompleted) {
                          _controller.complete(controller);
                        }
                      },
                      // onCameraIdle: API 호출 및 마커 업데이트
                      onCameraIdle: () {
                        if (!_suppressApiOnCameraIdle) {
                          // heavy 작업을 프레임 종료 후에 실행하여 애니메이션과 분리
                          SchedulerBinding.instance.addPostFrameCallback((_) async {
                            await viewModel.fetchPetSalonData('반려동물미용');
                            _mapController.clearOverlays();
                            for (var salon in viewModel.salons) {
                              NMarker marker = NMarker(
                                id: salon.title,
                                position: NLatLng(salon.mapy, salon.mapx),
                              );
                              _mapController.addOverlay(marker);
                              marker.setOnTapListener((NMarker marker) {
                                showModalBottomSheet(
                                  context: context,
                                  barrierColor: Colors.transparent,
                                  builder: (BuildContext context) {
                                    return Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(36.0),
                                        ),
                                      ),
                                      padding: EdgeInsets.fromLTRB(25.0, 16.0, 25.0, 16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            salon.title,
                                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            '주소: ${salon.address}',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            '전화번호: ${salon.telephone}',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          SizedBox(height: 8),
                                          InkWell(
                                            child: Text(
                                              '인스타그램, 블로그, SNS',
                                              style: TextStyle(fontSize: 16, color: Colors.blue),
                                            ),
                                            onTap: () {
                                              if (salon.link.isNotEmpty) {
                                                viewModel.openLink(salon);
                                              } else {
                                                showGeneralDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  barrierLabel: 'Dismiss',
                                                  barrierColor: Colors.black54,
                                                  transitionDuration: Duration(milliseconds: 300),
                                                  pageBuilder: (context, animation, secondaryAnimation) {
                                                    return Center(
                                                      child: Container(
                                                        width: 300,
                                                        height: 300,
                                                        padding: EdgeInsets.all(16.0),
                                                        color: Colors.white,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text('앱체에서 링크 미지정'),
                                                            SizedBox(height: 5),
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                              child: Text('닫기'),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  transitionBuilder: (context, animation, secondaryAnimation, child) {
                                                    return FadeTransition(
                                                      opacity: animation,
                                                      child: child,
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                          ),
                                          SizedBox(height: 5),
                                          ElevatedButton(
                                            child: Text('닫기'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              });
                            }
                          });
                        } else {
                          _suppressApiOnCameraIdle = false;
                        }
                      },
                      // 지도 이동이 시작되면(사용자 제스처) 패널을 닫기 위한 콜백
                      onCameraChange: (reason, animated) {
                        if (_isSearchResultsVisible &&
                            !_suppressApiOnCameraIdle &&
                            _panelController.status != AnimationStatus.reverse) {
                          _dismissSearchResults();
                        }
                      },
                    ),
                    if (viewModel.isLoading)
                      Positioned.fill(
                        child: Center(
                          child: Opacity(
                            opacity: 0.9,
                            child: Transform.scale(
                              scale: 0.21,
                              child: Lottie.asset('assets/animations/loadingGreyPaw.json'),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          // 검색 결과 패널 (슬라이딩 패널)
          if (_isSearchResultsVisible)
            Builder(builder: (context) {
              final panelHeight = MediaQuery.of(context).size.height * 0.4;
              return Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: panelHeight,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    // 패널 배경 탭 시 닫기
                    _dismissSearchResults();
                  },
                  onVerticalDragUpdate: (details) {
                    _handleVerticalDragUpdate(details, panelHeight);
                  },
                  onVerticalDragEnd: _handleVerticalDragEnd,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 15,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // 상단 헤더: "검색결과"
                          Container(
                            height: 40,
                            alignment: Alignment.center,
                            child: Text(
                              '검색결과',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: viewModel.salons.length,
                              itemBuilder: (context, index) {
                                final salon = viewModel.salons[index];
                                return ListTile(
                                  title: Text(salon.title),
                                  subtitle: Text(salon.address),
                                  trailing: Text(salon.telephone),
                                  onTap: () async {
                                    // 리스트 아이템 탭 시, 카메라 이동 전 플래그 세팅하여 API 재요청 방지
                                    setState(() {
                                      _suppressApiOnCameraIdle = true;
                                    });
                                    final controller = await _controller.future;
                                    await controller.updateCamera(
                                      NCameraUpdate.scrollAndZoomTo(
                                        target: NLatLng(salon.mapy, salon.mapx),
                                        zoom: 17,
                                      ),
                                    );
                                    // 패널은 그대로 유지합니다.
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
