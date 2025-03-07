import 'package:flutter/material.dart';

import 'pet.dart';

class Reservation {
  // 가게 이름
  String name;
  // 가게 여는 시간
  TimeOfDay openTime;
  // 가게 닫는 시간
  TimeOfDay closeTime;
  // 가게 주소
  String address;

  // 선택된 날짜
  DateTime date;
  // 예약 시간
  String reservedTime;
  // 디자이너
  String designer;
  // 시술
  Set<String> services;
  // 시술 받을 강아지(Pet 타입을 넣어야할듯)
  String petName;

  Reservation({
    required this.name,
    required this.openTime,
    required this.closeTime,
    required this.address,
    required this.date,
    required this.reservedTime,
    required this.designer,
    required this.services,
    required this.petName,
  });
}
