import 'package:flutter/material.dart';
import 'package:meongmeong_hairshop/providers/user_provider.dart';
import 'package:meongmeong_hairshop/views/reservation/reservation_list_screen.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/reservation_viewmodel.dart';

class ReservationDetailScreen extends StatefulWidget {
  String createdAt;
  ReservationDetailScreen({super.key, required this.createdAt});

  @override
  State<ReservationDetailScreen> createState() => _ReservationDetailScreenState();
}

class _ReservationDetailScreenState extends State<ReservationDetailScreen> {
  ReservationFirestoreService _firestoreService = ReservationFirestoreService();
  Future<Map<String, dynamic>> _reservation = Future.value({});

  @override
  void initState() {
    super.initState();
    _reservation = _firestoreService.getReservation(widget.createdAt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('예약 상세 정보'),
        backgroundColor: Colors.green,
      ),
      body: Consumer<UserProvider>(
        builder: (_, userProvider, __) {
          return FutureBuilder(
            future: _reservation,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    '텅...',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }

              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${snapshot.data!['userName']}님 예약 상세 정보',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 15),
                      Text(
                        snapshot.data!['name'],
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text('일정   ', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('${snapshot.data!['date'].toString().substring(0, 10)} ${snapshot.data!['reservedTime']}'),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text('시술   ', style: TextStyle(fontWeight: FontWeight.bold)),
                          // 시술 종류가 많아서 길어지면 ...으로 나타냄
                          Container(
                            width: 250,
                            child: Text(
                              '${snapshot.data!['services']}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text('디자이너   ', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('${snapshot.data!['designer']} (${snapshot.data!['position']})'),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text('보호자   ', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('${snapshot.data!['userName']} (${snapshot.data!['petName']})'),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text('금액   ', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('${snapshot.data!['totalFee']} 원'),
                        ],
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("예약 취소"),
                                    content: Text("예약을 취소하시겠습니까?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("취소"),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await _firestoreService.deleteReservation(widget.createdAt);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("예약이 취소되었습니다.")),
                                          );
                                        },
                                        child: Text(
                                          "확인",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              '예약 취소',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          );
        },
      ),
    );
  }
}