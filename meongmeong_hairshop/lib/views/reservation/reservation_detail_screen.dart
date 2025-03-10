import 'package:flutter/material.dart';
import 'package:meongmeong_hairshop/providers/user_provider.dart';
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

  initState() {
    super.initState();
    print(widget.createdAt);
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
        builder: (_, UserProvider, _) {
          return FutureBuilder(
            future: _reservation, 
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('텅...', style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold),));
              }
          
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${snapshot.data!['userName']}님 예약 상세 정보'),
                      Text(snapshot.data!['name'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('일정    '),
                          Text('${snapshot.data!['date'].toString().substring(0,10)} ${snapshot.data!['reservedTime']}'),
                        ],
                      ),
          
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('시술    '),
                          Container(
                            width: 250,
                            child: Text('${snapshot.data!['services']},', maxLines: 1, overflow: TextOverflow.ellipsis,)),
                        ],
                      ),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('디자이너    '),
                          Text('${snapshot.data!['designer']} ${snapshot.data!['position']}'),    
                        ],
                      ),
          
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('보호자    '),
                          Text('${snapshot.data!['userName']}(${snapshot.data!['petName']})'),     
                        ],
                      ),
                  
                      // Text('결제 수단: ${snapshot.data!['position']}'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('금액    '),
                          Text('${snapshot.data!['totalFee']} 원'),     
                        ],
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return CircularProgressIndicator();
            }
            },
            );
        }
      ),
    );
  }
}