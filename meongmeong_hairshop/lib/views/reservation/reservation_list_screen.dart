import 'package:flutter/material.dart';
import 'package:meongmeong_hairshop/providers/reservation_provider.dart';
import 'package:meongmeong_hairshop/providers/user_provider.dart';
import 'package:meongmeong_hairshop/viewmodels/reservation_viewmodel.dart';
import 'package:provider/provider.dart';

class ReservationListScreen extends StatefulWidget {

  ReservationListScreen({super.key});

  @override
  State<ReservationListScreen> createState() => _ReservationListScreenState();
}

class _ReservationListScreenState extends State<ReservationListScreen> {
  ReservationFirestoreService _firestoreService = ReservationFirestoreService();
  
  Future<List<Map<String, dynamic>>> _reservations = Future.value([]);

    @override
    void initState() {
      super.initState();
      fetchReservations();
    }

    Future<void> fetchReservations() async {
      final userProvider = context.read<UserProvider>();
      setState(() {
        _reservations = _firestoreService.getUserReservations(userProvider.user.username);
      });
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 
        Text('예약 목록'),
        backgroundColor: Colors.green,
        ),
        
      body: Consumer<UserProvider>(
        builder: (_, userProvider, _) {
          return Consumer<ReservationProvider>(
            builder: (context, reservationProvider, child) {
              return FutureBuilder(
                future: _reservations,
                builder: (context, snapshot) {
                  // 데이터가 없는 경우
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    
                    return Center(child: Text('텅...', style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold),));
                  }
                  // 데이터가 있는 경우
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        if (snapshot.data![index]['userName'] == userProvider.user.username) {
                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ListTile(
                            title: Text(snapshot.data![index]['name'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                            subtitle: Text('${snapshot.data![index]['designer']} ${snapshot.data![index]['position']}'),
                            trailing: Text('${snapshot.data![index]['date'].toString().substring(0,10)} ${snapshot.data![index]['reservedTime']}'), 
                          
                            onTap: () {
                              Navigator.pushNamed(context, '/reservationDetail', arguments: snapshot.data![index]['createdAt']).then((_) => fetchReservations());
                            },
                            shape: Border(
                              bottom: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              );
            }
          );
        }
      ),
    );
  }
}