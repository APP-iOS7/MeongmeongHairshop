import 'package:flutter/material.dart';
import 'package:meongmeong_hairshop/providers/reservation_provider.dart';
import 'package:provider/provider.dart';

class DesignerScreen extends StatefulWidget {
  const DesignerScreen({super.key});

  @override
  State<DesignerScreen> createState() => _DesignerScreenState();
}

class _DesignerScreenState extends State<DesignerScreen> {
  List<String> designers = ['김하준', '박민우', '박서윤', '이도현', '정민수'];
  List<String> positions = ['디자이너', '디자이너', '디자이너', '실장', '원장'];
  int? selectedIndex; // 선택된 디자이너의 인덱스

  @override
  Widget build(BuildContext context) {
    return Consumer<ReservationProvider>(
        builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal, // 가로 스크롤
              child: Row(
                children: List.generate(designers.length, (index) {
                  bool isSelected = selectedIndex == index;
                  
                  return GestureDetector(
                    onTap: () {
                      provider.setDesignerSelected();
                      setState(() {
                        selectedIndex = index; // 선택된 디자이너 변경
                        provider.updateDesigner(designers[index]);
                        provider.setPosition(positions[index]);
                      });
                    },
        
                    child: Container(
                      width: 80,
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.green : Colors.white, // 선택 시 초록색
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 디자이너 이름
                          Text(designers[index],
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black),
                          ),
                          SizedBox(height: 5),
                          
                          // 디자이너 직책
                          Text(positions[index],
                            style: TextStyle(fontSize: 14, color: isSelected ? Colors.white : Colors.black),
                          ),
                        ],
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
