import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class TableCalendarScreen extends StatefulWidget {
  const TableCalendarScreen({super.key});

  @override
  State<TableCalendarScreen> createState() => _TableCalendarScreenState();
}

class _TableCalendarScreenState extends State<TableCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TableCalendar(
          locale: 'ko_KR',
          firstDay: DateTime.utc(2021, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },

          headerStyle: HeaderStyle(
            titleCentered: true,
            titleTextFormatter: (date, locale) => DateFormat.yMMMM(locale).format(date),
            formatButtonVisible: false,
          ),
          // 오늘 날짜를 일반 텍스트로 표시
          calendarBuilders: CalendarBuilders(
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
      ),
    );
  }
}