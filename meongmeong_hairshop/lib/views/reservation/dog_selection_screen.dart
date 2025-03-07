import 'package:flutter/material.dart';
import 'package:meongmeong_hairshop/providers/reservation_provider.dart';
import 'package:provider/provider.dart';

class DogSelectionScreen extends StatefulWidget {
  const DogSelectionScreen({super.key});

  @override
  State<DogSelectionScreen> createState() => _DogSelectionScreenState();
}

class _DogSelectionScreenState extends State<DogSelectionScreen> {
  List<String> Dogs = ['감자', '뽀삐', '코코', '몽이'];
  String? selectedDog;

  @override
  Widget build(BuildContext context) {
    return Consumer<ReservationProvider>(
        builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.all(5)),
            SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(Dogs.length, (index) {
                  bool isSelected = selectedDog == Dogs[index]; // 선택 여부 확인
              
                  return GestureDetector(
                    onTap: () {
                      
                      setState(() {
                        if (isSelected) { // 해제
                          selectedDog = null;
                          provider.setPetSelected();
                        } else { // 선택
                          // 초기 선택시에만 선택 상태 변경
                          if (selectedDog == null) {
                            provider.setPetSelected();
                          }
                          selectedDog = Dogs[index];
                          provider.updatePet(Dogs[index]);
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
                      child: Text(Dogs[index], style: TextStyle(fontSize: 14, color: isSelected ? Colors.white : Colors.black, // 선택된 버튼의 텍스트 색상 변경
                        fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      }
    );
  }
}