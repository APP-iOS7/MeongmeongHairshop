import 'package:flutter/material.dart';

class Reservation {
  final DateTime date;
  final TimeOfDay time;
  final String designer;
  final List<String> services;

  Reservation({
    required this.date,
    required this.time,
    required this.designer,
    required this.services,
  });
}