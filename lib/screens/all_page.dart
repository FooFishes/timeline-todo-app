import 'package:flutter/material.dart';
import 'package:timeline_todo_app/widgets/list.dart';

class AllPage extends StatelessWidget {
  const AllPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Page'),
      ),
      body: Center(
        child: MyList(),
      ),
    );
  }
}
