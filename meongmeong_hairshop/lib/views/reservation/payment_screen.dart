import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meongmeong_hairshop/providers/reservation_provider.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('결제 화면'),
        backgroundColor: Colors.green,
        ),
      body: Consumer<ReservationProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('예약날짜', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                Text('${DateFormat('MM. dd (E) ', 'ko_KR').format(provider.reservation.date)} ${provider.reservation.reservedTime}', style: TextStyle(fontSize: 15, color: Colors.grey,),),
                SizedBox(height: 20),
            
                Text('디자이너', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                Text(provider.reservation.designer, style: TextStyle(fontSize: 15, color: Colors.grey,),),
                SizedBox(height: 20),
                
                Text('시술 메뉴', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                Text('${provider.reservation.services}', style: TextStyle(fontSize: 15, color: Colors.grey,),),
                SizedBox(height: 20),
                
                // user 정보 가져와야함.
                Text('예약자 정보', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                Text('박민우(${provider.reservation.petName})', style: TextStyle(fontSize: 15, color: Colors.grey,),),
                SizedBox(height: 20),
                
                Text('결제 수단', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                SizedBox(height: 300,),
                Container(
                  width: double.infinity,
                  height: 70,
                  child: FloatingActionButton(
                    onPressed: () {},
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, 
                    ),
                    backgroundColor: Colors.green,
                    child: Text('결제', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),)
                    ),
                )
                
              ],
            ),
          );
        }
      ),
    );
  }
}