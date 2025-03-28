import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/instance_manager.dart';
import 'package:timeline_todo_app/bindings/home_binding.dart';
import 'package:timeline_todo_app/screens/all_page.dart';
import 'package:timeline_todo_app/screens/home_page.dart';
import 'package:timeline_todo_app/screens/recents_page.dart';
import 'package:timeline_todo_app/screens/settings_page.dart';
import 'package:timeline_todo_app/screens/timeline_page.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      getPages: [
        GetPage(
          name: '/',
          page: () => HomePage(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: '/recents',
          page: () => RecentsPage(),
        ),
        GetPage(
          name: '/timeline',
          page: () => TimelinePage(),
        ),
        GetPage(
          name: '/all',
          page: () => AllPage(),
        ),
        GetPage(
          name: '/settings',
          page: () => SettingsPage(),
        ),
      ],
      initialRoute: '/',
    );
  }
}
