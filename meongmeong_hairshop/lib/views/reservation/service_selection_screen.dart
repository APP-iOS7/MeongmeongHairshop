import 'package:flutter/material.dart';
import 'package:meongmeong_hairshop/providers/reservation_provider.dart';
import 'package:provider/provider.dart';

class ServiceSelection extends StatefulWidget {
  @override
  _ServiceSelectionState createState() => _ServiceSelectionState();
}

class _ServiceSelectionState extends State<ServiceSelection> {
  List<String> services = ['컷', '펌', '염색', '클리닉'];
  Set<String> selectedServices = {}; // 선택된 서비스 저장 (여러 개 선택 가능)

  @override
  Widget build(BuildContext context) {
    return Consumer<ReservationProvider>(
        builder: (context, provider, child) {
        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(services.length, (index) {
              bool isSelected = selectedServices.contains(services[index]);
        
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedServices.remove(services[index]); // 이미 선택된 경우 해제
                      provider.updateDeleteServices(services[index]);
                      if (selectedServices.isEmpty) {
                        provider.setServicesSelected();
                      }
                    } else {
                      selectedServices.add(services[index]); // 선택되지 않은 경우 추가
                      provider.updateAddServices(services[index]);
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
                  child: Text(services[index], style: TextStyle(fontSize: 16, color: isSelected ? Colors.white : Colors.black, // 선택된 버튼의 텍스트 색상 변경
                    fontWeight: FontWeight.bold,
                    ),
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