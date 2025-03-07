import 'package:flutter/material.dart';
import 'package:meongmeong_hairshop/models/reservation.dart';


class ReservationProvider with ChangeNotifier {
  Reservation _reservation = Reservation(name: '', address: '', openTime: TimeOfDay.now(), closeTime: TimeOfDay.now(), date: DateTime.now(), reservedTime: '', designer: '', services: {}, petName: '');
  
  bool isDateSelected = false;
  bool isReservedTimeSelected = false;
  bool isDesignerSelected = false;
  bool isServicesSelected = false;
  bool isPetSelected = false;

  Reservation get reservation => _reservation;

  void updateName(String name) {
    _reservation.name = name;
    notifyListeners();
  }

  void updateOpenTime(TimeOfDay openTime) {
    _reservation.openTime = openTime;
    notifyListeners();
  }

  void updateCloseTime(TimeOfDay closeTime) {
    _reservation.closeTime = closeTime;
    notifyListeners();
  }

  void updateAddress(String address) {
    _reservation.address = address;
    notifyListeners();
  }

  void updateDate(DateTime date) {
    _reservation.date = date;
    notifyListeners();
  }

  void updateReservedTime(String reservedTime) {
    _reservation.reservedTime = reservedTime;
    notifyListeners();
  }

  void updateDesigner(String designer) {
    _reservation.designer = designer;
    notifyListeners();
  }

  void updateAddServices(String service) {
    _reservation.services.add(service);
    notifyListeners();
  }

  void updateDeleteServices(String service) {
    _reservation.services.remove(service);
    notifyListeners();
  }

  void updatePet(String petName) {
    _reservation.petName = petName;
    notifyListeners();
  }

  void setDateSelected() {
    isDateSelected = true;
    notifyListeners();
  }

  void setReservedTimeSelected() {
    isReservedTimeSelected = !isReservedTimeSelected;
    notifyListeners();
  }

  void setDesignerSelected() {
    isDesignerSelected = true;
    notifyListeners();
  }

  void setServicesSelected() {
    isServicesSelected = !isServicesSelected;
    notifyListeners();
  }

  void setPetSelected() {
    isPetSelected = !isPetSelected;
    notifyListeners();
  }
}
