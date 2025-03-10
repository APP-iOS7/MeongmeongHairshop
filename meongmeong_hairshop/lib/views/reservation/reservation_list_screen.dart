import 'package:flutter/material.dart';
import 'package:meongmeong_hairshop/providers/reservation_provider.dart';
import 'package:meongmeong_hairshop/viewmodels/reservation_viewmodel.dart';
import 'package:provider/provider.dart';

class ReservationListScreen extends StatefulWidget {

  ReservationListScreen({super.key});

  @override
  State<ReservationListScreen> createState() => _ReservationListScreenState();
}

class _ReservationListScreenState extends State<ReservationListScreen> {
  FirestoreService _firestoreService = FirestoreService();
  
  Future<List<Map<String, dynamic>>> _reservations = Future.value([]);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 초기에 예약정보를 firestore에서 가져옴
    _reservations = _firestoreService.getAllReservations();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 
        Text('예약 목록'),
        backgroundColor: Colors.green,
        ),
        // firestore에서 데이터를 다 가져올 때 UI를 그리는 빌더 
      body: Consumer<ReservationProvider>(
        builder: (context, provider, child) {
          return FutureBuilder(
            future: _reservations,
            builder: (context, snapshot) {
              // 데이터가 없는 경우
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                print('예약 내용이 없습니다!');
                return Center(child: Text('텅...', style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold),));
              }
              // 데이터가 있는 경우
              if (snapshot.hasData) {
                return TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/reservation');
                  },
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      if (snapshot.data![index]['userName'] == provider.userName) {
                      return Padding(
                        
                        padding: const EdgeInsets.all(20.0),
                        child: ListTile(
                          title: Text(snapshot.data![index]['name'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          subtitle: Text('${snapshot.data![index]['designer']} ${snapshot.data![index]['position']}'),
                          trailing: Text('${snapshot.data![index]['date'].toString().substring(0,10)} ${snapshot.data![index]['reservedTime']}'), 
                        ),
                      );
                    }
                  },
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