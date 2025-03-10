import 'package:flutter/material.dart';
import 'package:meongmeong_hairshop/providers/pet_provider.dart';
import 'package:meongmeong_hairshop/providers/reservation_provider.dart';
import 'package:provider/provider.dart';

class DogSelectionScreen extends StatefulWidget {
  const DogSelectionScreen({super.key});

  @override
  State<DogSelectionScreen> createState() => _DogSelectionScreenState();
}

class _DogSelectionScreenState extends State<DogSelectionScreen> {
  String? selectedDog;

  @override
  Widget build(BuildContext context) {
    return Consumer<PetProvider>(
      builder: (_, petProvider, _) {
        // 받아올 때 dynamic타입이므로 List<String>타입으로 바꿔주는 과정이 필요함
        List<String> dogs = petProvider.pets.isNotEmpty ? petProvider.pets.map((pet) => pet.name).toList().cast<String>()
        : []; // pets가 비어있다면 빈 리스트 반환

        // 품종
        List<String> breeds = petProvider.pets.isNotEmpty ? petProvider.pets.map((pet) => pet.breed).toList().cast<String>() : [];

        // 더미데이터
        // List<String> dogs = ['감자', '뽀삐', '초코', '나비'];

        if (dogs.isEmpty) {
          return Center(child: Text('시술받을 강아지가 없습니다! 강아지를 추가해주세요!!', style: TextStyle(color: Colors.grey),));
        }
        return Consumer<ReservationProvider>(
            builder: (context, provider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.all(5)),
                SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(dogs.length, (index) {
                      bool isSelected = selectedDog == dogs[index]; // 선택 여부 확인
                  
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
                              selectedDog = dogs[index];
                              provider.updatePet(dogs[index]);
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
                          child: Text('${dogs[index]}(${breeds[index]})', style: TextStyle(fontSize: 14, color: isSelected ? Colors.white : Colors.black, // 선택된 버튼의 텍스트 색상 변경
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
    );
  }
}