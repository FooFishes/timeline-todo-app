import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
            elevation: 4, // 卡片阴影
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10), // 外边距
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Event Title",
                style: TextStyle(fontSize: 18),
              ),
            ),
    );
  }
}