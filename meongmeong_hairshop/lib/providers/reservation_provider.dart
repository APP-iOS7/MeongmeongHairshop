import 'package:flutter/material.dart';
import 'package:meongmeong_hairshop/models/reservation.dart';


class ReservationProvider with ChangeNotifier {
  // 유저 이름
  String userName = '';
  
  Reservation _reservation = Reservation(name: '', address: '', openTime: TimeOfDay.now(), closeTime: TimeOfDay.now(), date: DateTime.now(), reservedTime: '', designer: '', services: {}, petName: '');
  // getter
  Reservation get reservation => _reservation;
  
  // 버튼 클릭시 상태 저장
  bool _isDateSelected = false;
  bool _isReservedTimeSelected = false;
  bool _isDesignerSelected = false;
  bool _isServicesSelected = false;
  bool _isPetSelected = false;

  // getter
  bool get isDateSelected => _isDateSelected;
  bool get isReservedTimeSelected => _isReservedTimeSelected;
  bool get isDesignerSelected => _isDesignerSelected;
  bool get isServicesSelected => _isServicesSelected; 
  bool get isPetSelected => _isPetSelected;

  // 시술 메뉴 종류
  List<String> _services = ['스페셜컷','목욕 + 위생미용(소)','목욕 + 위생미용(중)' , '목욕 + 위생미용(대)','목욕(소)', '목욕(중)', '목욕(대)'];
  // 시술 가격
  List<int> _prices = [100000,50000,100000,150000,20000,30000,40000];
  // getter
  List<String> get services => _services;
  List<int> get prices => _prices;

  // 시술 총 금액
  int _totalFee = 0;
  // 디자이너 직책
  String _position = '';
  // getter
  int get totalFee => _totalFee;
  String get position => _position;

  // 모든 정보 리셋
  void allReset() {
    _reservation = Reservation(name: '', address: '', openTime: TimeOfDay.now(), closeTime: TimeOfDay.now(), date: DateTime.now(), reservedTime: '', designer: '', services: {}, petName: '');
    userName = '';
    _isDateSelected = false;
    _isReservedTimeSelected = false;
    _isDesignerSelected = false;
    _isServicesSelected = false;
    _isPetSelected = false;
    _totalFee = 0;
    _position = '';
    notifyListeners();
  }
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
    _isDateSelected = true;
    notifyListeners();
  }

  void setReservedTimeSelected() {
    _isReservedTimeSelected = !_isReservedTimeSelected;
    notifyListeners();
  }

  void setDesignerSelected() {
    _isDesignerSelected = true;
    notifyListeners();
  }

  void setServicesSelected() {
    _isServicesSelected = !_isServicesSelected;
    notifyListeners();
  }

  void setPetSelected() {
    _isPetSelected = !_isPetSelected;
    notifyListeners();
  }

  void setTotalFee(int totalFee) {
    _totalFee = totalFee;
    notifyListeners();
  }

  void setPosition(String position) {
    _position = position;
    notifyListeners();
  }
}
