// 시간 선택 화면
import 'package:flutter/material.dart';
import 'package:meongmeong_hairshop/providers/reservation_provider.dart';
import 'package:provider/provider.dart';

class TimeSlotScreen extends StatefulWidget {
  const TimeSlotScreen({super.key});

  @override
  State<TimeSlotScreen> createState() => _TimeSlotScreenState();
}

class _TimeSlotScreenState extends State<TimeSlotScreen> {
  List<String> timeSlots = [
    "12:00",
    "13:00",
    "14:00",
    "15:00",
    "16:00",
    "17:00",
    "18:00",
    "19:00",
    "20:00",
    "21:00",
  ];

  String? selectedSlot; // 선택된 시간 저장

  @override
  Widget build(BuildContext context) {
    return Consumer<ReservationProvider>(
      builder: (context, provider, child) {
        return GridView.builder(
          physics: NeverScrollableScrollPhysics(), // 스크롤 비활성화 하는 거...
          
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2,
          ),
          itemCount: timeSlots.length,
          itemBuilder: (context, index) {
            String time = timeSlots[index];
            bool isSelected = selectedSlot == time;
        
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedSlot = null; // 같은 시간 클릭하면 선택 해제
                    provider.setReservedTimeSelected();
                  } else {
                    // 초기 선택시에만 선택 상태 변경
                    if (selectedSlot == null) {
                      provider.setReservedTimeSelected();
                    }

                    selectedSlot = time; // 새로운 시간 선택
                    provider.updateReservedTime(time);
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? Colors.green : Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                alignment: Alignment.center,
                child: Text(
                  time,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        );
      }
    );
  }
}
