import 'package:flutter/material.dart';

class AllPage extends StatelessWidget {
  const AllPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Page'),
      ),
      body: const Center(
        child: Text('This is All Page.'),
      ),
    );
  }
}