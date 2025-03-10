import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../models/salon.dart';
import '../providers/map_provider.dart';
import '../wigets/search_panel_widget.dart';
import '../wigets/marker_modal_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final Completer<NaverMapController> _controller = Completer();
  late NaverMapController _mapController;
  String searchString = '';

  // 검색 결과 패널 애니메이션 관련
  late AnimationController _panelController;
  late Animation<Offset> _slideAnimation;
  bool _isSearchResultsVisible = false;
  bool _shouldShowPanel = false; // 새 검색 시에만 true로 세팅

  // 마커 모달 애니메이션 관련
  late AnimationController _modalController;
  late Animation<Offset> _modalSlideAnimation;

  // API 재요청 방지 플래그 (ListTile 탭 시 true로 설정)
  bool _suppressApiOnCameraIdle = false;

  // 마커 모달 열림 상태와 선택된 살롱
  bool _isMarkerModalOpen = false;
  Salon? _selectedSalon;

  @override
  void initState() {
    super.initState();
    _panelController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      value: 0.0,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    ).animate(_panelController);

    _modalController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      value: 0.0,
    );
    _modalSlideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    ).animate(_modalController);
  }

  @override
  void dispose() {
    _panelController.dispose();
    _modalController.dispose();
    super.dispose();
  }

  void _dismissSearchResults() {
    _panelController.reverse().then((_) {
      setState(() {
        _isSearchResultsVisible = false;
        _shouldShowPanel = false;
      });
    });
  }

  void _handlePanelVerticalDragUpdate(
    DragUpdateDetails details,
    double panelHeight,
  ) {
    double fractionDragged = details.primaryDelta! / panelHeight;
    _panelController.value = (_panelController.value - fractionDragged).clamp(
      0.0,
      1.0,
    );
  }

  void _handlePanelVerticalDragEnd(DragEndDetails details, double panelHeight) {
    if (_panelController.value < 0.8 || details.primaryVelocity! > 300) {
      _dismissSearchResults();
    } else {
      _panelController.forward();
    }
  }

  void _handleModalVerticalDragUpdate(
    DragUpdateDetails details,
    double modalHeight,
  ) {
    double fractionDragged = details.primaryDelta! / modalHeight;
    _modalController.value = (_modalController.value - fractionDragged).clamp(
      0.0,
      1.0,
    );
  }

  void _handleModalVerticalDragEnd(DragEndDetails details, double modalHeight) {
    if (_modalController.value < 0.8 || details.primaryVelocity! > 300) {
      _closeMarkerModal();
    } else {
      _modalController.forward();
    }
  }

  void _closeMarkerModal() {
    if (_modalController.status == AnimationStatus.dismissed ||
        !_isMarkerModalOpen)
      return;
    _modalController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _isMarkerModalOpen = false;
          _selectedSalon = null;
        });
      }
    });
  }

  /// 지도에 마커 추가
  Future<void> _updateMarkers() async {
    final provider = context.read<MapProvider>();
    _mapController.clearOverlays();
    for (var salon in provider.salons) {
      NMarker marker = NMarker(
        id: salon.title,
        position: NLatLng(salon.mapy, salon.mapx),
      );
      _mapController.addOverlay(marker);
      marker.setOnTapListener((_) {
        setState(() {
          _isMarkerModalOpen = true;
          _selectedSalon = salon;
        });
        _modalController.forward();
      });
    }
  }

  // ListTile 탭 시 호출되는 콜백 (검색 결과 패널 내부)
  Future<void> _onListTileTap(Salon salon) async {
  // ListTile 탭 시, 카메라 이동으로 인한 onCameraIdle API 호출 및 패널 닫힘 방지
  _suppressApiOnCameraIdle = true;
  await _mapController.updateCamera(
    NCameraUpdate.scrollAndZoomTo(
      target: NLatLng(salon.mapy, salon.mapx),
      zoom: 17,
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MapProvider>();

    final initialPosition =
        provider.currentPosition != null
            ? NLatLng(
              provider.currentPosition!.latitude,
              provider.currentPosition!.longitude,
            )
            : const NLatLng(37.5666102, 126.9783881);

    // 새 검색 결과가 생기면 패널 슬라이드 업
    if (provider.salons.isNotEmpty &&
        !_isSearchResultsVisible &&
        _shouldShowPanel) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _isSearchResultsVisible = true;
        });
        _panelController.forward();
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('펫미용실 검색')),
      body: Stack(
        children: [
          Column(
            children: [
              // 검색 입력부
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onSubmitted: (query) async {
                          setState(() {
                            _shouldShowPanel = true;
                          });
                          await provider.fetchPetSalonData(query);
                          await _updateMarkers();
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
                      onPressed: () async {
                        setState(() {
                          _shouldShowPanel = true;
                        });
                        await provider.fetchPetSalonData(searchString);
                        await _updateMarkers();
                      },
                    ),
                  ],
                ),
              ),
              // 지도 영역
              Expanded(
                child: Stack(
                  children: [
                    NaverMap(
                      options: NaverMapViewOptions(locationButtonEnable: true),
                      onMapReady: (controller) {
                        _mapController = controller;
                        provider.setMapController(controller);
                        if (!_controller.isCompleted) {
                          _controller.complete(controller);
                        }
                      },
                      onCameraIdle: () async {
                        if (!_suppressApiOnCameraIdle) {
                          await provider.fetchPetSalonData('반려동물미용');
                          await _updateMarkers();
                        } else {
                          _suppressApiOnCameraIdle = false;
                        }
                      },
                      onCameraChange: (reason, animated) {
                        if (_isMarkerModalOpen &&
                            _modalController.status !=
                                AnimationStatus.reverse) {
                          _closeMarkerModal();
                        }
                        // 검색 패널은 지도 움직임에 의해 닫히지만,
                        // ListTile 탭 시 _suppressApiOnCameraIdle가 true이면 닫히지 않도록 함.
                        if (_isSearchResultsVisible &&
                            !_suppressApiOnCameraIdle &&
                            _panelController.status !=
                                AnimationStatus.reverse) {
                          _dismissSearchResults();
                        }
                      },
                    ),
                    // API 호출 중 Lottie 애니메이션 표시 (적절한 크기로)
                    if (provider.isLoading)
                      Positioned.fill(
                        child: Center(
                          child: Opacity(
                            opacity: 0.9,
                            child: Lottie.asset(
                              'assets/animations/loadingGreyPaw.json',
                              width: 150,
                              height: 150,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          // 검색 결과 패널 (슬라이딩)
          if (_isSearchResultsVisible)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: MediaQuery.of(context).size.height * 0.4,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _dismissSearchResults,
                onVerticalDragUpdate: (details) {
                  _handlePanelVerticalDragUpdate(
                    details,
                    MediaQuery.of(context).size.height * 0.4,
                  );
                },
                onVerticalDragEnd: (details) {
                  _handlePanelVerticalDragEnd(
                    details,
                    MediaQuery.of(context).size.height * 0.4,
                  );
                },
                child: SlideTransition(
                  position: _slideAnimation,
                  child: SearchPanelWidget(onListTileTap: _onListTileTap),
                ),
              ),
            ),
          // 마커 모달
          if (_isMarkerModalOpen && _selectedSalon != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  _handleModalVerticalDragUpdate(
                    details,
                    MediaQuery.of(context).size.height * 0.3,
                  );
                },
                onVerticalDragEnd: (details) {
                  _handleModalVerticalDragEnd(
                    details,
                    MediaQuery.of(context).size.height * 0.3,
                  );
                },
                child: MarkerModalWidget(
                  salon: _selectedSalon!,
                  animationController: _modalController,
                  modalSlideAnimation: _modalSlideAnimation,
                  onLinkTap: () async {
                    if (_selectedSalon!.link.isNotEmpty) {
                      await provider.openLink(_selectedSalon!);
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
                        transitionBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      );
                    }
                  },
                  onClose: _closeMarkerModal,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
