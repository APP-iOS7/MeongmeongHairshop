import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meongmeong_hairshop/providers/reservation_provider.dart';
import 'package:meongmeong_hairshop/providers/user_provider.dart';
import 'package:meongmeong_hairshop/viewmodels/reservation_viewmodel.dart';
import 'package:meongmeong_hairshop/views/login_screen.dart';
import 'package:provider/provider.dart';


class PaymentScreen extends StatelessWidget {
  
  PaymentScreen({super.key});

  // firestore 연결
  ReservationFirestoreService _firestoreService = ReservationFirestoreService();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('결제 화면'),
        backgroundColor: Colors.green,
        ),
      body: Consumer<UserProvider>(
        builder: (_, userProvider, _) {
          return Consumer<ReservationProvider>(
            builder: (context, reservationProvider, child) {
              
              // 예약 provider에도 유저 이름 저장
              reservationProvider.userName = userProvider.user.username;
              int totalFee = 0;
              // 추가요금(직급에 따라)
              int additionalFee = 0;
              
              for (String service in reservationProvider.reservation.services) {
                totalFee += reservationProvider.prices[reservationProvider.services.indexOf(service)];
              }
              
              // 직급에 따라 추가 비용 발생 
              if (reservationProvider.position == '원장') {
                     additionalFee = 30000;
                } else if (reservationProvider.position == '실장') {
                    additionalFee = 10000;
                } else {
                      additionalFee = 0;
              }
              totalFee += additionalFee;
          
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('예약날짜', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    Text('${DateFormat('MM. dd (E) ', 'ko_KR').format(reservationProvider.reservation.date)} ${reservationProvider.reservation.reservedTime}', style: TextStyle(fontSize: 15),),
                    SizedBox(height: 20),
                
                    Text('디자이너', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    Text('${reservationProvider.reservation.designer} ${reservationProvider.position}', style: TextStyle(fontSize: 15,),),
                    SizedBox(height: 20),
                    
                    Text('시술 메뉴', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          
                    Column(
                      children: [
                        for (String service in reservationProvider.reservation.services)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(service),
                              // 내가 찾는 서비스가 전체 서비스의 몇 번째 인덱스에 위치해있는지
                              // 가격과 서비스가 일대일로 대응하므로 가능.
                              Text('${reservationProvider.prices[reservationProvider.services.indexOf(service)]}원'), 
                            ],
                          ),
          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(reservationProvider.position),
                              Text('$additionalFee원'),
                            ],
                          ),
                        SizedBox(height: 10),
                        // 총금액 위에 줄긋기 위해서
                        // container를 만들어서 윗부분만 그리도록 했다.
                        Container(
                          width: double.infinity,
                          height: 5,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            )
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('총금액'),
                            Text('$totalFee원'),
                          ],
                        ),
                      ],
                    ),
                    
          
                    SizedBox(height: 20),
                    
                    // user 정보 가져와야함.
                    // 
                    Text('예약자 정보', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // userprovider에서 정보를 가져오는 부분
                        Text(reservationProvider.userName),
                        Text("("),
                        Text(reservationProvider.reservation.petName),
                        Text(")"),
                      ],
                    ),
                    SizedBox(height: 20),
                    
                    Text('결제 수단', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          
                    Container(
                      width: double.infinity,
                      height: 70,
                      child: FloatingActionButton(
                        onPressed: () {
                          reservationProvider.setTotalFee(totalFee);
                          if(reservationProvider.reservation.services.isNotEmpty) {
                            _firestoreService.addReservation(reservationProvider.userName,reservationProvider.reservation.name, reservationProvider.reservation.openTime, reservationProvider.reservation.closeTime, reservationProvider.reservation.address, reservationProvider.reservation.date, reservationProvider.reservation.reservedTime, reservationProvider.reservation.designer, reservationProvider.position,reservationProvider.reservation.services, reservationProvider.reservation.petName, totalFee);
                            reservationProvider.allReset();
                            
                            // 홈(?)으로 돌아가기
                            // 기존 navigator 스택 모두 제거
                            Navigator.pushAndRemoveUntil(
                              context,MaterialPageRoute(builder: (context) => LoginScreen()),(route) => false, 
                            );
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, 
                        ),
                        backgroundColor: Colors.green,
                        child: Text('결제', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),)
                        ),
                    ),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(onPressed: () {
                          Navigator.pushNamed(context, '/reservationList');
                        }, 
                        child: Text('예약내역 보기', style: TextStyle(color: Colors.grey[700]),),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          );
        }
      ),
    );
  }
}