import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meongmeong_hairshop/providers/reservation_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class TableCalendarScreen extends StatefulWidget {
  const TableCalendarScreen({super.key});

  @override
  State<TableCalendarScreen> createState() => _TableCalendarScreenState();
}

class _TableCalendarScreenState extends State<TableCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool isDateSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ReservationProvider>(
        builder: (context, provider, child) {
          return Center(
            child: TableCalendar(
              // 기본 설정
              locale: 'ko_KR',
              firstDay: DateTime.utc(2021, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },

              // 날짜 선택했을 때 로직
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  isDateSelected = true;
                  provider.updateDate(selectedDay);
                  provider.setDateSelected();
                });
              },
              // 헤더 스타일 설정
              headerStyle: HeaderStyle(
                titleCentered: true,
                titleTextFormatter: (date, locale) => DateFormat.yMMMM(locale).format(date),
                formatButtonVisible: false,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),

                ),
              ),
              
              // 요일 스타일 설정
              daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: TextStyle(
                  color: Colors.red,
                ),
              ),

              // 주말의 기준을 일요일로
              weekendDays: [
                DateTime.sunday,
              ],
              
              // 주말 날짜를 빨간색으로 표시
              calendarStyle: CalendarStyle(
                weekendTextStyle: TextStyle(
                  color: Colors.red,
                )
              ),
              
              // 날짜 표시 설정
              calendarBuilders: CalendarBuilders(
                
                // 오늘 날짜를 일반 텍스트로 표시
                todayBuilder: (context, date, _) {
                  return Center(
                    child: Text(
                      date.day.toString(),
                      style: const TextStyle(color: Colors.black), 
                    ),
                  );
                },
          
                // 선택한 날짜는 사각형으로 표시
                selectedBuilder: (context, date, events) {
                  return Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.green, 
                        shape: BoxShape.rectangle, 
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        date.day.toString(),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
      ),
    );
  }
}
