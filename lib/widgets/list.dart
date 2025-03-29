import 'package:flutter/material.dart';

class MyList extends StatelessWidget {
  final List<String> items = List<String>.generate(20, (i) => "Item ${i + 1}");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: items.length,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (context, index) {
          return Card(
            elevation: 4, // 卡片阴影
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10), // 外边距
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                items[index],
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 添加新事件的逻辑
          print("Add new event");
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}