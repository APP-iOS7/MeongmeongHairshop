import 'package:flutter/material.dart';
import 'package:meongmeong_hairshop/models/reservation.dart';
import 'package:meongmeong_hairshop/providers/reservation_provider.dart';
import 'package:provider/provider.dart';

class PaymentListScreen extends StatefulWidget {
  List<String> payments = ['카드', '현금', '네이버페이', '카카오페이'];
  List<Color> colors = [Colors.grey, Colors.blue, Colors.green, Colors.yellow];

  PaymentListScreen({super.key});

  @override
  State<PaymentListScreen> createState() => _PaymentListScreenState();
}

class _PaymentListScreenState extends State<PaymentListScreen> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Consumer<ReservationProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(widget.payments.length, (index) {
              bool isSelected = selectedIndex == index;
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                    provider.setPaymentMethod(widget.payments[index]);
                  });
                },
                child: Container(
                  width: 100,
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected ? widget.colors[index % widget.colors.length] : Colors.white, 
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(widget.payments[index],
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      }
    );
  }
}