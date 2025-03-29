import 'package:get/get.dart';
import 'package:timeline_todo_app/controllers/event_list_controller.dart';

class EventListBinding extends Bindings {
  @override
  void dependencies() {
    // 懒加载 EventListController，当 EventListScreen 第一次显示时创建
    // 它会自动找到 InitialBinding 中注册的 IEventRepository
    Get.lazyPut<EventListController>(() => EventListController());
  }
}