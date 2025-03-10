import 'package:flutter/material.dart';
import '../models/salon.dart';

class MarkerModalWidget extends StatelessWidget {
  final Salon salon;
  final AnimationController animationController;
  final Animation<Offset> modalSlideAnimation;
  final VoidCallback onClose;
  final Future<void> Function() onLinkTap;

  const MarkerModalWidget({
    Key? key,
    required this.salon,
    required this.animationController,
    required this.modalSlideAnimation,
    required this.onClose,
    required this.onLinkTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FadeTransition(
      opacity: animationController.drive(Tween(begin: 0.0, end: 1.0)),
      child: SlideTransition(
        position: modalSlideAnimation,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1,
            vertical: MediaQuery.of(context).size.height * 0.02,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(36.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 15,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // 드래그 핸들
              GestureDetector(
                onVerticalDragUpdate: (details) {},
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                  margin: EdgeInsets.only(bottom: 8),
                ),
              ),
              Text(
                salon.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '주소: ${salon.address}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '전화번호: ${salon.telephone}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 8),
              InkWell(
                child: Text(
                  '인스타그램, 블로그, SNS',
                  style: theme.textTheme.titleMedium?.copyWith(color: Colors.blue),
                ),
                onTap: onLinkTap,
              ),
              SizedBox(height: 5),
              ElevatedButton(
                onPressed: onClose,
                child: Text('닫기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
