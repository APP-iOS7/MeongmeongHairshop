import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meongmeong_hairshop/providers/reservation_provider.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatelessWidget {
  
  PaymentScreen({super.key});

  // 추가요금(직책에 따라)
  int additionalFee = 0;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('결제 화면'),
        backgroundColor: Colors.green,
        ),
      body: Consumer<ReservationProvider>(
        builder: (context, provider, child) {
          
          // 시술 메뉴 가격 포맷
          String resultText = '';  
          
          int totalFee = 0;

          // 정렬...
          for (int i = 0; i < provider.services.length; i++) {
            if (provider.reservation.services.contains(provider.services[i])) {
              if (provider.services[i].length < 10) {
                resultText += provider.services[i];
                resultText += '                                      ${provider.prices[i]}원\n';
              } else {
                resultText += provider.services[i];
                resultText += '                      ${provider.prices[i]}원\n';
              }                  

                totalFee += provider.prices[i];
             }
          }
          // 직급에 따라 추가 비용 발생 
          if (provider.position == '원장') {
                 additionalFee = 30000;
            } else if (provider.position == '실장') {
                additionalFee = 10000;
            } else {
                  additionalFee = 0;
          }
          totalFee += additionalFee;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('예약날짜', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                Text('${DateFormat('MM. dd (E) ', 'ko_KR').format(provider.reservation.date)} ${provider.reservation.reservedTime}', style: TextStyle(fontSize: 15, color: Colors.grey,),),
                SizedBox(height: 20),
            
                Text('디자이너', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                Text('${provider.reservation.designer} ${provider.position}', style: TextStyle(fontSize: 15, color: Colors.grey,),),
                SizedBox(height: 20),
                
                Text('시술 메뉴', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                Text(resultText.trim(), style: TextStyle(fontSize: 15, color: Colors.grey,), textAlign: TextAlign.left,),
                Text('${provider.position}                                            ${additionalFee}원', style: TextStyle(fontSize: 15, color: Colors.grey,), textAlign: TextAlign.left,),
                Text('-'*40, style: TextStyle(fontSize: 15, color: Colors.grey,), textAlign: TextAlign.left,),
                Text('총금액                                         $totalFee원', style: TextStyle(fontSize: 15,),),
                
                SizedBox(height: 20),
                
                // user 정보 가져와야함.
                Text('예약자 정보', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                Text('박민우(${provider.reservation.petName})', style: TextStyle(fontSize: 15, color: Colors.grey,),),
                SizedBox(height: 20),
                
                Text('결제 수단', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                // SizedBox(height: 300,),
                Container(
                  width: double.infinity,
                  height: 70,
                  child: FloatingActionButton(
                    onPressed: () {
                      provider.setTotalFee(totalFee);
                      print('${provider.totalFee}');
                    },
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