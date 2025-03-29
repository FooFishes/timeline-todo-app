import 'package:get/get.dart';
import 'package:timeline_todo_app/controllers/add_event_controller.dart';

class AddEventBinding extends Bindings {
  @override
  void dependencies() {
    // 懒加载 AddEventController
    Get.lazyPut<AddEventController>(() => AddEventController());
    // 注意：IEventRepository 应该已经在 InitialBinding 中注册了
  }
}