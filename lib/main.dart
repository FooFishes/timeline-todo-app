// import 'package:flutter/material.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';
// import 'package:get/get_navigation/src/routes/get_route.dart';
// import 'package:timeline_todo_app/bindings/home_binding.dart';
// import 'package:timeline_todo_app/screens/all_page.dart';
// import 'package:timeline_todo_app/screens/home_page.dart';
// import 'package:timeline_todo_app/screens/recents_page.dart';
// import 'package:timeline_todo_app/screens/settings_page.dart';
// import 'package:timeline_todo_app/screens/timeline_page.dart';

// void main() {
//   runApp(MainApp());
// }

// class MainApp extends StatelessWidget {
//   MainApp({super.key});


//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         useMaterial3: true,
//       ),
//       getPages: [
//         GetPage(
//           name: '/',
//           page: () => HomePage(),
//           binding: HomeBinding(),
//         ),
//         GetPage(
//           name: '/recents',
//           page: () => RecentsPage(),
//         ),
//         GetPage(
//           name: '/timeline',
//           page: () => TimelinePage(),
//         ),
//         GetPage(
//           name: '/all',
//           page: () => AllPage(),
//         ),
//         GetPage(
//           name: '/settings',
//           page: () => SettingsPage(),
//         ),
//       ],
//       initialRoute: '/',
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeline_todo_app/bindings/add_event_binding.dart';
import 'package:timeline_todo_app/bindings/initial_binding.dart';
import 'package:timeline_todo_app/screens/add_event_screen.dart';
import 'package:timeline_todo_app/screens/event_list_screen.dart';
import 'package:timeline_todo_app/bindings/event_list_binding.dart'; // 引入页面的 Binding

void main() async {
  // 确保 Flutter 核心服务已初始化
  WidgetsFlutterBinding.ensureInitialized();

  // --- (可选) 初始化其他服务，例如 Firebase, 日志等 ---

  // 运行 App
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '事件清单 App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true, // 推荐使用 Material 3
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // --- GetX 配置 ---
      initialBinding: InitialBinding(), // 设置全局初始绑定
      // --- 方式一：直接指定初始页面和它的绑定 ---
      initialRoute: '/eventList', // 定义一个初始路由名
      getPages: [
        GetPage(
          name: '/eventList',
          page: () => const EventListScreen(),
          binding: EventListBinding(), // 绑定此页面的 Controller
        ),
        GetPage(
          name: '/addEvent', 
          page: () => const AddEventScreen(),
          binding: AddEventBinding(), // 绑定添加/编辑事件的 Controller
        ),
        // TODO: 添加其他页面的路由和绑定
        // GetPage(name: '/addEditEvent', page: () => AddEditEventScreen(), binding: AddEditEventBinding()),
      ],
      debugShowCheckedModeBanner: false, // 隐藏 Debug 标签
    );
  }
}