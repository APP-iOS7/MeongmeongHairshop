import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../models/reservation.dart';

class ReservationFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = "reservations";
  // 데이터 추가 
  Future<void> addReservation(String userName, String name, TimeOfDay openTime, TimeOfDay closeTime, String address, DateTime date, String reservedTime, String designer, String position, Set<String> services, String petName, int totalFee, String paymentMethod) async {
    DateTime createdAt = DateTime.now(); // 예약 건들을 생성한 날짜로 구분하기 위해서
    try {
      await _firestore.collection(collectionName).doc(createdAt.toString()).set({
        'userName': userName,
        'name': name,
        'openTime': {'hour': openTime.hour, 'minute': openTime.minute}, // TimeOfDay 저장 방식 변경
        'closeTime': {'hour': closeTime.hour, 'minute': closeTime.minute}, 
        'address': address,
        'date': Timestamp.fromDate(date), // DateTime을 Timestamp로 변환
        'reservedTime': reservedTime,
        'designer': designer,
        'position': position,
        'services': services.toList(),
        'petName': petName,
        'totalFee': totalFee,
        'paymentMethod': paymentMethod,
      });
      print("예약 추가 완료!");
    } catch (e) {
      print("예약 추가 실패: $e");
    }
  }

  // 전체 예약 불러오기
  Future<List<Map<String, dynamic>>> getUserReservations(String userName) async {
  try {
    QuerySnapshot snapshot = await _firestore.collection('reservations').where('userName', isEqualTo: userName).get();
    
    List<Map<String, dynamic>> reservations = snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>; // Firestore 데이터 가져오기
      var createdAt = doc.id; 

      return {
        'userName': data.containsKey('userName') ? data['userName'] : 'Unknown',
        'name': data.containsKey('name') ? data['name'] : 'Unknown',
        'openTime': data.containsKey('openTime') ? data['openTime'] : {'hour': 0, 'minute': 0},
        'closeTime': data.containsKey('closeTime') ? data['closeTime'] : {'hour': 0, 'minute': 0},
        'address': data.containsKey('address') ? data['address'] : 'No Address',
        'date': data.containsKey('date') ? (data['date'] as Timestamp).toDate() : DateTime.now(),
        'reservedTime': data.containsKey('reservedTime') ? data['reservedTime'] : '',
        'designer': data.containsKey('designer') ? data['designer'] : '',
        'position': data.containsKey('position') ? data['position'] : '',
        'services': data.containsKey('services') ? List<String>.from(data['services']) : [],
        'petName': data.containsKey('petName') ? data['petName'] : 'Unknown',
        'totalFee': data.containsKey('totalFee') ? data['totalFee'] : 0,
        'createdAt': createdAt,
        'paymentMethod': data.containsKey('paymentMethod') ? data['paymentMethod'] : '',
      };
      print("예약 불러오기 완료!");
    }).toList();

    return reservations; // 리스트 리턴
  } catch (e) {
    print("예약 데이터 가져오기 실패: $e");
    return []; // 실패 시 빈 리스트 리턴
  } 
  }

  // 예약 하나 가져오기
  Future<Map<String, dynamic>> getReservation(String createdAt) async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection(collectionName).doc(createdAt).get();
      
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>; // Firestore 데이터 가져오기

        return {
          'userName': data.containsKey('userName') ? data['userName'] : 'Unknown',
          'name': data.containsKey('name') ? data['name'] : 'Unknown',
          'openTime': data.containsKey('openTime') ? data['openTime'] : {'hour': 0, 'minute': 0},
          'closeTime': data.containsKey('closeTime') ? data['closeTime'] : {'hour': 0, 'minute': 0},
          'address': data.containsKey('address') ? data['address'] : 'No Address',
          'date': data.containsKey('date') ? (data['date'] as Timestamp).toDate() : DateTime.now(),
          'reservedTime': data.containsKey('reservedTime') ? data['reservedTime'] : '',
          'designer': data.containsKey('designer') ? data['designer'] : '',
          'position': data.containsKey('position') ? data['position'] : '',
          'services': data.containsKey('services') ? List<String>.from(data['services']) : [],
          'petName': data.containsKey('petName') ? data['petName'] : 'Unknown',
          'totalFee': data.containsKey('totalFee') ? data['totalFee'] : 0,
          'paymentMethod': data.containsKey('paymentMethod') ? data['paymentMethod'] : '',
        };
        print("예약 불러오기 완료!");
      } else {
        return {};
      }
    } catch (e) {
      print("예약 데이터 가져오기 실패: $e");
      return {}; // 실패 시 빈 리스트 리턴
    }
  }

  // 예약 모두 가져오기
  Future<List<Map<String, dynamic>>> getAllReservations() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection(collectionName).get();
      
      List<Map<String, dynamic>> reservations = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>; // Firestore 데이터 가져오기
        var createdAt = doc.id; 

        return {
          'userName': data.containsKey('userName') ? data['userName'] : 'Unknown',
          'name': data.containsKey('name') ? data['name'] : 'Unknown',
          'openTime': data.containsKey('openTime') ? data['openTime'] : {'hour': 0, 'minute': 0},
          'closeTime': data.containsKey('closeTime') ? data['closeTime'] : {'hour': 0, 'minute': 0},
          'address': data.containsKey('address') ? data['address'] : 'No Address',
          'date': data.containsKey('date') ? (data['date'] as Timestamp).toDate() : DateTime.now(),
          'reservedTime': data.containsKey('reservedTime') ? data['reservedTime'] : '',
          'designer': data.containsKey('designer') ? data['designer'] : '',
          'position': data.containsKey('position') ? data['position'] : '',
          'services': data.containsKey('services') ? List<String>.from(data['services']) : [],
          'petName': data.containsKey('petName') ? data['petName'] : 'Unknown',
          'totalFee': data.containsKey('totalFee') ? data['totalFee'] : 0,
          'createdAt': createdAt,
        };
        print("예약 불러오기 완료!");
      }).toList();

      return reservations; // 리스트 리턴
    } catch (e) {
      print("예약 데이터 가져오기 실패: $e");
      return []; // 실패 시 빈 리스트 리턴
    } 
  }
  // 예약 삭제
  Future<void> deleteReservation(String createdAt) async {
    try {
      await _firestore.collection(collectionName).doc(createdAt).delete();
      print("예약 삭제 완료! (ID: $createdAt)");
    } catch (e) {
      print("예약 삭제 실패: $e");
    }
  }
}
