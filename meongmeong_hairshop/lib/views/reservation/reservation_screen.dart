import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meongmeong_hairshop/providers/reservation_provider.dart';
import 'package:meongmeong_hairshop/views/reservation/designer_screen.dart';
import 'package:meongmeong_hairshop/views/reservation/dog_selection_screen.dart';
import 'package:meongmeong_hairshop/views/reservation/service_selection_screen.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'table_calendar_screen.dart';
import 'timeslot_screen.dart';

class ReservationScreen extends StatelessWidget {

  // 더미데이터
  String name = '살롱드위드멍';
  TimeOfDay openTime = TimeOfDay(hour: 12, minute: 0);
  TimeOfDay closeTime = TimeOfDay(hour: 21, minute: 0);
  String address = '서울특별시 송파구 가락로 98 4층';

  ReservationScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('예약화면'), backgroundColor: Colors.green),
      body: Consumer<ReservationProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 가게 이름
                        Text(name, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                        
                        // 가게 영업시간
                        Row(
                          children: [
                            Icon(Icons.schedule, size: 20),
                            SizedBox(width: 10),
                            Text('${openTime.toString().substring(10, 15)} ~ ${closeTime.toString().substring(10, 15)}'),
                          ],
                        ),
                  
                        // 가게 위치
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 20),
                            SizedBox(width: 10),
                            Text(address),
                          ],
                        ),
                        SizedBox(height: 20),
                  
                        // 날짜와 시간 
                        Text('날짜와 시간을 선택해주세요.',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                  
                        // 캘린더
                        SizedBox(
                          width: double.infinity,
                          height: 400,
                          child: TableCalendarScreen(),
                        ),
                  
                        // 시간 선택 버튼들
                        SizedBox(
                          width: double.infinity,
                          height: 150,
                          child: TimeSlotScreen(),
                        ),
                        SizedBox(height: 10),
                  
                        // 디자이너 선택
                        Text('디자이너를 선택해주세요.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        DesignerScreen(),
                        SizedBox(height: 10),
                        
                        // 시술 선택
                        Text('시술 메뉴를 선택해주세요.',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        ServiceSelection(),
                        SizedBox(height: 10),
                  
                        // 시술 받을 강아지 선택
                        Text('시술 받을 강아지를 선택해주세요.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        DogSelectionScreen(),

                        // bool 여부
                        Text(provider.isDateSelected.toString()),
                        Text(provider.isReservedTimeSelected.toString()),
                        Text(provider.isDesignerSelected.toString()),
                        Text(provider.isServicesSelected.toString()),
                        Text(provider.isPetSelected.toString()),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 70,
                // 조건을 만족할 때만 활성화
                child: FloatingActionButton(onPressed: provider.isDateSelected && provider.isReservedTimeSelected && provider.isDesignerSelected && provider.isServicesSelected && provider.isPetSelected ? () {
                  provider.updateName(name);
                  provider.updateOpenTime(openTime);
                  provider.updateCloseTime(closeTime);
                  provider.updateAddress(address);       
                } : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, 
                ),
                backgroundColor: provider.isDateSelected && provider.isReservedTimeSelected && provider.isDesignerSelected && provider.isServicesSelected && provider.isPetSelected ? Colors.green : Colors.grey,
                child: Text('예약하기', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),)
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}
