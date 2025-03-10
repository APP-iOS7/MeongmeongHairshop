import 'package:flutter/material.dart';
import 'package:meongmeong_hairshop/providers/reservation_provider.dart';
import 'package:provider/provider.dart';

class TimeSlotScreen extends StatefulWidget {
  const TimeSlotScreen({super.key});

  @override
  State<TimeSlotScreen> createState() => _TimeSlotScreenState();
}

class _TimeSlotScreenState extends State<TimeSlotScreen> {
  List<String> timeSlots = [];
  String? selectedSlot; // 선택된 슬롯

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    generateTimeSlots();
  }

  // 가게 영업 시간 사이 1시간 간격의 리스트 생성
  void generateTimeSlots() {
    final provider = Provider.of<ReservationProvider>(context, listen: false);
    TimeOfDay current = provider.reservation.openTime;
    timeSlots.clear();

    while (_isBeforeOrEqual(current, provider.reservation.closeTime)) {
      timeSlots.add(_formatTimeOfDay(current));
      current = _addOneHour(current);
    }
  }

  TimeOfDay _addOneHour(TimeOfDay time) {
    int newHour = (time.hour + 1) % 24;
    return TimeOfDay(hour: newHour, minute: 0);
  }

  String _formatTimeOfDay(TimeOfDay time) {
    return '${time.toString().substring(10, 15)}'; 
  }

  bool _isBeforeOrEqual(TimeOfDay time1, TimeOfDay time2) {
    return time1.hour < time2.hour || (time1.hour == time2.hour && time1.minute <= time2.minute);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReservationProvider>(context, listen: false);

    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
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
                selectedSlot = null;
                provider.setReservedTimeSelected();
              } else {
                if (selectedSlot == null) {
                  provider.setReservedTimeSelected();
                }
                selectedSlot = time;
                provider.updateReservedTime(time);
              }
            });
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200), // 애니메이션 효과 추가
            decoration: BoxDecoration(
              color: isSelected ? Colors.green : Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.grey, width: 1),
            ),
            alignment: Alignment.center,
            child: Consumer<ReservationProvider>(
              builder: (context, provider, child) {
                return Text(
                  time,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}