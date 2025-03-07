import 'package:flutter/material.dart';
import 'package:meongmeong_hairshop/providers/reservation_provider.dart';
import 'package:provider/provider.dart';

class ServiceSelection extends StatefulWidget {
  @override
  _ServiceSelectionState createState() => _ServiceSelectionState();
}

class _ServiceSelectionState extends State<ServiceSelection> {
  Set<String> selectedServices = {}; // 선택된 서비스 저장 (여러 개 선택 가능)

  @override
  Widget build(BuildContext context) {
    return Consumer<ReservationProvider>(
        builder: (context, provider, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal, 
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(provider.services.length, (index) {
                bool isSelected = selectedServices.contains(provider.services[index]);
          
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedServices.remove(provider.services[index]); // 이미 선택된 경우 해제
                        provider.updateDeleteServices(provider.services[index]);
                        if (selectedServices.isEmpty) {
                          provider.setServicesSelected();
                        }
                      } else {
                        selectedServices.add(provider.services[index]); // 선택되지 않은 경우 추가
                        provider.updateAddServices(provider.services[index]);
                        if (!provider.isServicesSelected) {
                          provider.setServicesSelected();
                        }
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green : Colors.white, // 선택되면 초록색
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Text(provider.services[index], style: TextStyle(fontSize: 16, color: isSelected ? Colors.white : Colors.black, // 선택된 버튼의 텍스트 색상 변경
                      fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      }
    );
  }
}