import 'dart:async';
import 'package:get/get.dart';
import 'package:timeline_todo_app/models/event_model.dart';
import 'package:timeline_todo_app/repositories/event_repository.dart';
import 'package:timeline_todo_app/screens/add_event_screen.dart';

class EventListController extends GetxController {
  // 依赖注入 Repository 接口
  final IEventRepository _eventRepository = Get.find<IEventRepository>();

  // 使用 RxList 存储事件列表，UI 会自动响应变化
  final RxList<Event> events = <Event>[].obs;
  // 加载状态
  final RxBool isLoading = true.obs;
  // 错误信息
  final RxnString errorMessage = RxnString(); // 可空的 RxString

  StreamSubscription<List<Event>>? _eventSubscription;

  @override
  void onInit() {
    super.onInit();
    _subscribeToEvents();
  }

  // 订阅事件流
  void _subscribeToEvents() {
    isLoading.value = true;
    errorMessage.value = null; // 清除旧错误
    _eventSubscription?.cancel(); // 取消旧的订阅

    _eventSubscription = _eventRepository.watchEvents().listen(
      (eventList) {
        events.assignAll(eventList); // 高效更新 RxList
        isLoading.value = false;
        errorMessage.value = null;
        print("Events updated: ${eventList.length}"); // Debug log
      },
      onError: (error) {
        print("Error fetching events: $error"); // Debug log
        isLoading.value = false;
        errorMessage.value = "加载事件失败: $error";
        // 可以考虑更友好的错误提示
      },
      onDone: () {
         isLoading.value = false;
         print("Event stream closed"); // Debug log
      }
    );
  }

  // 删除事件
  Future<void> deleteEvent(String id) async {
    try {
      await _eventRepository.deleteEvent(id);
      // 数据库更新后，Stream 会自动触发，无需手动移除 list 中的元素
      Get.snackbar('成功', '事件已删除');
    } catch (e) {
      Get.snackbar('错误', '删除事件失败: $e');
    }
  }

  // 切换事件完成状态
  Future<void> toggleEventCompletion(Event event) async {
    try {
      final updatedEvent = event.copyWith(isCompleted: !event.isCompleted);
      await _eventRepository.updateEvent(updatedEvent);
      // Stream 会自动更新 UI
    } catch (e) {
      Get.snackbar('错误', '更新事件状态失败: $e');
      // 可以考虑回滚 UI 状态或重试
    }
  }

  // 跳转到添加页面
  void goToAddEvent() {
    // 使用 GetX 路由
    // Get.toNamed(AppRoutes.addEditEvent);
    // 或者直接导航
    // Get.to(() => AddEditEventScreen());
    Get.toNamed('/addEvent'); // 使用 GetX 路由
    print("Navigate to Add Event Screen"); // Placeholder
     // 实际项目中会导航到 AddEditEventScreen
     // 导航后，如果添加成功，返回此页面时 Stream 会自动更新列表
  }


  @override
  void onClose() {
    _eventSubscription?.cancel(); // 清理 StreamSubscription
    super.onClose();
  }
}