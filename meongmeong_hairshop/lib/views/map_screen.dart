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
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  // 네이버 맵 컨트롤러
  final Completer<NaverMapController> _controller = Completer();
  late NaverMapController _mapController;
  String searchString = '';

  // 검색 결과 패널 애니메이션 관련 변수
  late AnimationController _panelController;
  late Animation<Offset> _slideAnimation;
  bool _isSearchResultsVisible = false;
  bool _shouldShowPanel = false; // 새 검색 시에만 true로 세팅

  // 마커 모달 애니메이션 관련 변수
  late AnimationController _modalController;
  late Animation<Offset> _modalSlideAnimation;

  // 리스트 아이템 탭 후, API 재요청 방지를 위한 플래그
  bool _suppressApiOnCameraIdle = false;

  // 마커 모달 열림 상태와 선택된 살롱
  bool _isMarkerModalOpen = false;
  Salon? _selectedSalon;

  @override
  void initState() {
    super.initState();
    // 검색 결과 패널 애니메이션 초기화
    _panelController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      value: 0.0, // 시작은 숨긴 상태
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1), // 화면 아래쪽 (숨김)
      end: Offset(0, 0), // 제자리 (완전히 열린 상태)
    ).animate(_panelController);

    // 마커 모달 애니메이션 초기화 (슬라이드 & 페이드 효과)
    _modalController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      value: 0.0, // 시작은 숨긴 상태
    );
    _modalSlideAnimation = Tween<Offset>(
      begin: Offset(0, 1), // 화면 아래쪽에서 시작
      end: Offset(0, 0), // 정상 위치
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

  void _handleVerticalDragUpdate(
    DragUpdateDetails details,
    double panelHeight,
  ) {
    double fractionDragged = details.primaryDelta! / panelHeight;
    _panelController.value = (_panelController.value - fractionDragged).clamp(
      0.0,
      1.0,
    );
  }

  void _handleVerticalDragEnd(DragEndDetails details, double panelHeight) {
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

  // 마커 모달 닫기: reverse 애니메이션이 완료된 후 위젯 트리에서 제거하여 닫힘 효과를 확실하게 보여줍니다.
  void _closeMarkerModal() {
    if (_modalController.status == AnimationStatus.dismissed ||
        !_isMarkerModalOpen)
      return;

    _modalController.reverse().then((_) {
      // 애니메이션이 완전히 종료된 후 setState로 상태를 업데이트합니다.
      if (mounted) {
        setState(() {
          _isMarkerModalOpen = false;
          _selectedSalon = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MapViewModel>();

    // 새 검색 요청 시 검색 결과 패널 오픈
    if (viewModel.salons.isNotEmpty &&
        !_isSearchResultsVisible &&
        _shouldShowPanel) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _isSearchResultsVisible = true;
        });
        _panelController.forward();
      });
    }

    final initialPosition =
        viewModel.currentPosition != null
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
                        onSubmitted: (query) async {
                          setState(() {
                            _shouldShowPanel = true;
                          });

                          await viewModel.fetchPetSalonData(
                            query,
                          ); // 데이터 로딩이 완료될 때까지 대기

                          _mapController.clearOverlays(); // 기존 마커 삭제

                          for (var salon in viewModel.salons) {
                            NMarker marker = NMarker(
                              id: salon.title,
                              position: NLatLng(salon.mapy, salon.mapx),
                            );

                            _mapController.addOverlay(marker);

                            // 마커 클릭 시 모달 표시
                            marker.setOnTapListener((NMarker marker) {
                              setState(() {
                                _isMarkerModalOpen = true;
                                _selectedSalon = salon;
                              });
                              _modalController.forward();
                            });
                          }
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

                        await viewModel.fetchPetSalonData(
                          searchString,
                        ); // 데이터 로딩이 완료될 때까지 대기

                        _mapController.clearOverlays(); // 기존 마커 삭제

                        for (var salon in viewModel.salons) {
                          NMarker marker = NMarker(
                            id: salon.title,
                            position: NLatLng(salon.mapy, salon.mapx),
                          );
                          _mapController.addOverlay(marker);

                          // 마커 클릭 시 모달 표시
                          marker.setOnTapListener((NMarker marker) {
                            setState(() {
                              _isMarkerModalOpen = true;
                              _selectedSalon = salon;
                            });
                            _modalController.forward();
                          });
                        }
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
                      onCameraIdle: () {
                        if (!_suppressApiOnCameraIdle) {
                          SchedulerBinding.instance.addPostFrameCallback((
                            _,
                          ) async {
                            await viewModel.fetchPetSalonData('반려동물미용');
                            _mapController.clearOverlays();
                            for (var salon in viewModel.salons) {
                              NMarker marker = NMarker(
                                id: salon.title,
                                position: NLatLng(salon.mapy, salon.mapx),
                              );
                              _mapController.addOverlay(marker);
                              // 마커 탭 시 모달을 애니메이션과 함께 오버레이로 띄웁니다.
                              marker.setOnTapListener((NMarker marker) {
                                setState(() {
                                  _isMarkerModalOpen = true;
                                  _selectedSalon = salon;
                                });
                                _modalController.forward();
                              });
                            }
                          });
                        } else {
                          _suppressApiOnCameraIdle = false;
                        }
                      },
                      // 지도 이동(제스처) 시 모달 닫기 및 검색 패널 닫기
                      onCameraChange: (reason, animated) {
                        if (_isMarkerModalOpen &&
                            _modalController.status !=
                                AnimationStatus.reverse) {
                          _closeMarkerModal();
                        }
                        if (_isSearchResultsVisible &&
                            !_suppressApiOnCameraIdle &&
                            _panelController.status !=
                                AnimationStatus.reverse) {
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
                              child: Lottie.asset(
                                'assets/animations/loadingGreyPaw.json',
                              ),
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
            Builder(
              builder: (context) {
                final panelHeight = MediaQuery.of(context).size.height * 0.4;
                final theme = Theme.of(context);

                return Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: panelHeight,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _dismissSearchResults,
                    onVerticalDragUpdate: (details) {
                      _handleVerticalDragUpdate(details, panelHeight);
                    },
                    onVerticalDragEnd: (details) {
                      _handleVerticalDragEnd(details, panelHeight);
                    },
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.scaffoldBackgroundColor,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(36.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, -2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 54,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      borderRadius: BorderRadius.circular(2.5),
                                    ),
                                  ),
                                  SizedBox(height: 6.0),
                                  Text(
                                    '검색 결과',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Divider(height: 1, color: Colors.grey[300]),
                            Expanded(
                              child:
                                  viewModel.salons.isEmpty
                                      ? Center(
                                        child: Text(
                                          '검색 결과가 없습니다.',
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                      )
                                      : ListView.separated(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.0,
                                        ),
                                        itemCount: viewModel.salons.length,
                                        separatorBuilder:
                                            (context, index) => Divider(
                                              color: Colors.grey[300],
                                              height: 1,
                                            ),
                                        itemBuilder: (context, index) {
                                          final salon = viewModel.salons[index];

                                          return Material(
                                            color:
                                                Colors
                                                    .transparent, // 배경색을 투명하게 설정
                                            child: InkWell(
                                              onTap: () async {
                                                setState(() {
                                                  _suppressApiOnCameraIdle =
                                                      true;
                                                });
                                                final controller =
                                                    await _controller.future;
                                                await controller.updateCamera(
                                                  NCameraUpdate.scrollAndZoomTo(
                                                    target: NLatLng(
                                                      salon.mapy,
                                                      salon.mapx,
                                                    ),
                                                    zoom: 17,
                                                  ),
                                                );
                                              },
                                              splashColor: Colors.grey[350]!
                                                  .withValues(
                                                    alpha: 0.5,
                                                  ), // 물결 효과 색상
                                              splashFactory:
                                                  InkRipple.splashFactory,
                                              highlightColor:
                                                  Colors
                                                      .transparent, // 강조 효과 제거
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    12.0,
                                                  ), // 물결 효과 적용을 위해 설정
                                              child: Ink(
                                                decoration: BoxDecoration(
                                                  color:
                                                      theme
                                                          .cardColor, // 기존의 tileColor 대신 Ink로 설정
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        12.0,
                                                      ),
                                                ),
                                                child: ListTile(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                        vertical: 4.0,
                                                        horizontal: 20.0,
                                                      ),
                                                  title: Text(
                                                    salon.title,
                                                    style: theme
                                                        .textTheme
                                                        .titleMedium
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                  subtitle: Text(
                                                    salon.address,
                                                    style:
                                                        theme
                                                            .textTheme
                                                            .bodySmall,
                                                  ),
                                                  trailing: Text(
                                                    salon.telephone,
                                                    style:
                                                        theme
                                                            .textTheme
                                                            .bodySmall,
                                                  ),
                                                ),
                                              ),
                                            ),
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
              },
            ),
          // 커스텀 마커 모달 (오버레이, 슬라이드 및 페이드 애니메이션, 드래그로 닫기 기능 추가)
          if (_isMarkerModalOpen && _selectedSalon != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Builder(
                builder: (context) {
                  final modalHeight = MediaQuery.of(context).size.height * 0.3;
                  final theme = Theme.of(context);

                  return GestureDetector(
                    onVerticalDragUpdate: (details) {
                      _handleModalVerticalDragUpdate(details, modalHeight);
                    },
                    onVerticalDragEnd: (details) {
                      _handleModalVerticalDragEnd(details, modalHeight);
                    },
                    child: FadeTransition(
                      opacity: _modalController.drive(
                        Tween(begin: 0.0, end: 1.0),
                      ),
                      child: SlideTransition(
                        position: _modalSlideAnimation,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(36.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 15,
                                offset: Offset(0, -2),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.1,
                            vertical: MediaQuery.of(context).size.height * 0.02,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              // ✅ 추가된 손잡이(Drag Handle)
                              GestureDetector(
                                onVerticalDragUpdate: (details) {
                                  _handleModalVerticalDragUpdate(
                                    details,
                                    modalHeight,
                                  );
                                },
                                onVerticalDragEnd: (details) {
                                  _handleModalVerticalDragEnd(
                                    details,
                                    modalHeight,
                                  );
                                },
                                child: Container(
                                  width: 40,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(2.5),
                                  ),
                                  margin: EdgeInsets.only(bottom: 8.0),
                                ),
                              ),

                              Text(
                                _selectedSalon!.title,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '주소: ${_selectedSalon!.address}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '전화번호: ${_selectedSalon!.telephone}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              SizedBox(height: 8),
                              InkWell(
                                child: Text(
                                  '인스타그램, 블로그, SNS',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.blue,
                                  ),
                                ),
                                onTap: () {
                                  if (_selectedSalon!.link.isNotEmpty) {
                                    viewModel.openLink(_selectedSalon!);
                                  } else {
                                    showGeneralDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      barrierLabel: 'Dismiss',
                                      barrierColor: Colors.black54,
                                      transitionDuration: Duration(
                                        milliseconds: 300,
                                      ),
                                      pageBuilder: (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                      ) {
                                        return Center(
                                          child: Container(
                                            width: 300,
                                            height: 300,
                                            padding: EdgeInsets.all(16.0),
                                            color: Colors.white,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                              ),
                              SizedBox(height: 5),
                              ElevatedButton(
                                child: Text('닫기'),
                                onPressed: _closeMarkerModal,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
