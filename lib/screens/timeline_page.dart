import 'package:flutter/material.dart';

class TimelinePage extends StatelessWidget {
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timeline Page'),
      ),
      body: const Center(
        child: Text('This is Timeline Page.'),
      ),
    );
  }
}