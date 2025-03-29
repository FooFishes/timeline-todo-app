import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // 用于日期格式化
import 'package:timeline_todo_app/models/event_model.dart';
import 'package:timeline_todo_app/controllers/event_list_controller.dart';
// import 'package:timeline_todo_app/widgets/event_list_item.dart'; // 可选的自定义列表项

class EventListScreen extends GetView<EventListController> {
  const EventListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('事件清单'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: controller.goToAddEvent, // 跳转到添加页面
          ),
        ],
      ),
      body: Obx(() { // 使用 Obx 包裹需要响应式更新的部分
        if (controller.isLoading.value && controller.events.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value != null) {
          return Center(
            child: Text('错误: ${controller.errorMessage.value}'),
          );
        }

        if (controller.events.isEmpty) {
          return const Center(
            child: Text('还没有事件，点击 "+" 添加一个吧！'),
          );
        }

        // 使用 ListView 显示事件
        return ListView.builder(
          itemCount: controller.events.length,
          itemBuilder: (context, index) {
            final event = controller.events[index];
            // return EventListItem(event: event); // 使用自定义 Widget
            return _buildEventTile(event); // 或者直接在这里构建 ListTile
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
         onPressed: controller.goToAddEvent,
         child: const Icon(Icons.add),
       ),
    );
  }

  // 构建列表项 (示例)
  Widget _buildEventTile(Event event) {
     final dateFormat = DateFormat('yyyy-MM-dd HH:mm'); // 日期格式化

    return Dismissible( // 添加滑动删除功能
       key: Key(event.id), // 必须有唯一的 Key
       direction: DismissDirection.endToStart,
       background: Container(
         color: Colors.red,
         alignment: Alignment.centerRight,
         padding: const EdgeInsets.symmetric(horizontal: 20),
         child: const Icon(Icons.delete, color: Colors.white),
       ),
       confirmDismiss: (direction) async {
         // 显示确认对话框
         return await Get.dialog<bool>(
           AlertDialog(
             title: const Text('确认删除'),
             content: Text('确定要删除事件 "${event.name}" 吗？'),
             actions: [
               TextButton(
                 onPressed: () => Get.back(result: false), // 取消
                 child: const Text('取消'),
               ),
               TextButton(
                 onPressed: () => Get.back(result: true), // 确认
                 child: const Text('删除', style: TextStyle(color: Colors.red)),
               ),
             ],
           ),
         );
       },
       onDismissed: (direction) {
         controller.deleteEvent(event.id); // 调用 Controller 删除
       },
       child: ListTile(
        leading: Checkbox( // 显示完成状态
           value: event.isCompleted,
           onChanged: (bool? value) {
             if (value != null) {
                controller.toggleEventCompletion(event);
             }
           },
         ),
        title: Text(
          event.name,
          style: TextStyle(
            decoration: event.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        subtitle: Text(
            '开始: ${dateFormat.format(event.startTime)}${event.endTime != null ? '\n结束: ${dateFormat.format(event.endTime!)}' : ''}${event.isAllDay ? ' (全天)' : ''}'
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // TODO: 跳转到事件详情或编辑页面
          // Get.to(() => AddEditEventScreen(event: event)); // 传递 event 进行编辑
          print("Tapped on event: ${event.name}");
        },
      ),
    );
  }
}