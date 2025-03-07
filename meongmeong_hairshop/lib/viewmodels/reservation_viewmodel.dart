// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../models/reservation.dart';

// class FirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final String collectionName = "reservations";

//   /// 🔹 데이터 추가 (Firestore에 새로운 문서 생성)
//   Future<void> addReservation(String name, TimeOfDay openTime, TimeOfDay closeTime, String address, DateTime date, String reservedTime, String designer, Set<String> services, String petName) async {
//     try {
//       await _firestore.collection(collectionName).add({
//         'name': name,
//         'openTime': openTime.toString(),
//         'closeTime': closeTime.toString(),
//         'address': address,
//         'date': date.toString(),
//         'reservedTime': reservedTime,
//         'designer': designer,
//         'services': services.toList(),
//         'petName': petName,
//       });
//       print("예약 추가 완료!");
//     } catch (e) {
//       print("예약 추가 실패: $e");
//     }
//   }

//   /// 🔹 데이터 조회 (실시간 업데이트 Stream 사용)
//   Stream<List<Map<String, dynamic>>> getUsers() {
//     return _firestore.collection(collectionName)
//       .orderBy('createdAt', descending: true)
//       .snapshots()
//       .map((snapshot) {
//         return snapshot.docs.map((doc) {
//           return {
//             'id': doc.id,
//             'name': doc['name'],
//             'age': doc['age'],
//           };
//         }).toList();
//       });
//   }

//   /// 🔹 데이터 삭제 (특정 문서 ID를 기준으로 삭제)
//   Future<void> deleteUser(String userId) async {
//     try {
//       await _firestore.collection(collectionName).doc(userId).delete();
//       print("사용자 삭제 완료!");
//     } catch (e) {
//       print("삭제 실패: $e");
//     }
//   }
// }
