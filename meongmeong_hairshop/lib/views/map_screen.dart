import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../viewmodels/map_view_model.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // 네이버 맵 컨트롤러
  final Completer<NaverMapController> _controller = Completer();
  late NaverMapController _mapController;

  @override
  Widget build(BuildContext context) {
    // ViewModel 접근
    final viewModel = context.watch<MapViewModel>();

    // 현재 위치가 있으면 해당 좌표로 지도 초기화, 없으면 기본 좌표(서울 시청 근처)
    final initialPosition =
        viewModel.currentPosition != null
            ? NLatLng(
              viewModel.currentPosition!.latitude,
              viewModel.currentPosition!.longitude,
            )
            : const NLatLng(37.5666102, 126.9783881); // 예: 서울 시청 근처

    // 살롱 데이터를 지도에 표시할 마커 목록
    final markers =
        viewModel.salons.map((salon) {
          return NMarker(
            id: salon.title,
            position: NLatLng(salon.mapx, salon.mapy),
          );
        }).toList();
    final screenWidth = MediaQuery.of(context).size.width; // 화면 너비 가져오기
    final containerWidth = screenWidth * 0.8;

    return Scaffold(
      appBar: AppBar(title: const Text('펫미용실 검색')),
      body: Column(
        children: [
          // 검색 입력부
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onSubmitted: (query) {
                      // 엔터 입력 시 검색
                      viewModel.fetchPetSalonData(query);
                    },
                    decoration: const InputDecoration(
                      labelText: '검색어를 입력하세요.',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    final query = TextEditingController().text;
                    viewModel.fetchPetSalonData(query);
                  },
                ),
              ],
            ),
          ),

          // 로딩 상태 표시
          // if (viewModel.isLoading) const CircularProgressIndicator(),

          // 지도를 화면 일부에 확장
          Expanded(
            flex: 1,
            child: NaverMap(
              options: NaverMapViewOptions(locationButtonEnable: true),
              onMapReady: (controller) {
                _mapController = controller;
                viewModel.mapController = controller;
                _controller.complete(controller);
              },
              // onCameraChange: (reason, animated) {

              // },
              onCameraIdle: () async {
                // 카메라 이동이 끝난 후, 최신 살롱 데이터를 불러옴
                await viewModel.fetchPetSalonData('반려동물미용');

                // 기존 오버레이(마커)를 제거합니다.
                // (clearOverlays() 메서드가 없는 경우, 개별 제거하거나 updateOverlays()가 있다면 그 메서드를 사용하세요.)
                _mapController.clearOverlays();

                NMarker tmp;
                // salon 데이터에 있는 각 항목을 마커로 추가합니다.
                for (var salon in viewModel.salons) {
                  tmp = NMarker(
                    id: salon.title,
                    position: NLatLng(salon.mapy, salon.mapx),
                  );

                  _mapController.addOverlay(tmp);

                  tmp.setOnTapListener((NMarker marker) {
                    showModalBottomSheet(
                      context: context,
                      barrierColor: Colors.transparent,
                      builder: (BuildContext context) {
                        return Container(
                          width: containerWidth,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16.0),
                            ),
                          ),
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                salon.title,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text('주소: ${salon.address}'),
                              SizedBox(height: 8),
                              Text('전화번호: ${salon.telephone}'),
                              SizedBox(height: 8),
                              InkWell(
                                child: Text(
                                  '인스타그램, 블로그, SNS',
                                  style: TextStyle(color: Colors.blue),
                                ),
                                onTap: () async {
                                  final Uri url = Uri.parse(salon.link);
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(
                                      url,
                                      mode: LaunchMode.externalApplication,
                                    );
                                  } else {
                                    throw 'Could not launch ${salon.link}';
                                  }
                                },
                                // link 열기
                              ),
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
              },
            ),
          ),

          // 검색 결과 리스트
          // Expanded(
          //   flex: 3,
          //   child: ListView.builder(
          //     itemCount: viewModel.salons.length,
          //     itemBuilder: (context, index) {
          //       final salon = viewModel.salons[index];
          //       return ListTile(
          //         title: Text(salon.name),
          //         subtitle: Text(salon.address),
          //         trailing: Text(salon.phoneNumber),
          //         onTap: () async {
          //           // 리스트 아이템 탭 시, 해당 살롱 위치로 카메라 이동
          //           final controller = await _controller.future;
          //           await controller.updateCamera(
          //             NCameraUpdate.scrollAndZoomTo(
          //                 target: NLatLng(salon.latitude, salon.longitude),
          //                 zoom: 17,
          //             ),
          //           );
          //         },
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
