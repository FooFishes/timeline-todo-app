import 'package:flutter/material.dart';

class RecentsPage extends StatelessWidget {
  const RecentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recents Page'),
      ),
      body: const Center(
        child: Text('This is Recents Page.'),
      ),
    );
  }
}