import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeline_todo_app/controllers/home_controller.dart';
import 'package:timeline_todo_app/screens/all_page.dart';
import 'package:timeline_todo_app/screens/recents_page.dart';
import 'package:timeline_todo_app/screens/settings_page.dart';
import 'package:timeline_todo_app/screens/timeline_page.dart';

class HomePage extends GetView<HomeController> {
  HomePage({super.key});
  
  List<Widget> pages = [
     RecentsPage(),
     TimelinePage(),
     AllPage(),
     SettingsPage(),
  ];

  List<String> titles = [
    'Recents',
    'Timeline',
    'All',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: pages,
        ),
      ),
      bottomNavigationBar: Obx(() => NavigationBar(
        destinations: 
        <Widget>[
          NavigationDestination(
            icon: Icon(Icons.recent_actors), 
            label: titles[0],
            ),
          NavigationDestination(
            icon: const Icon(Icons.timeline),
            label: titles[1],
          ),
          NavigationDestination(
            icon: const Icon(Icons.list),
            label: titles[2],
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings),
            label: titles[3],
          ),
        ],
        onDestinationSelected: controller.changeIndex,
        selectedIndex: controller.selectedIndex.value,
        )
    ),
    );
  }
}