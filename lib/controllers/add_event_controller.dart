import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeline_todo_app/models/event_model.dart';
import 'package:timeline_todo_app/repositories/event_repository.dart';
import 'package:uuid/uuid.dart'; // 用于生成唯一 ID

class AddEventController extends GetxController {
  final IEventRepository _eventRepository = Get.find<IEventRepository>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>(); // 表单 Key

  // 表单字段的 Controller
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // 事件时间相关状态
  final Rx<DateTime?> startTime = Rx<DateTime?>(null);
  final Rx<DateTime?> endTime = Rx<DateTime?>(null);
  final RxBool isAllDay = false.obs;
  final RxBool isSaving = false.obs; // 保存状态

  // --- 日期和时间选择逻辑 ---

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: startTime.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      // 如果只选择了日期，时间部分保持不变或设为默认 (例如 00:00)
      // 如果之前已有时间，则保留时间部分
      final currentTime = startTime.value ?? DateTime.now();
      startTime.value = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        isAllDay.value ? 0 : currentTime.hour, // 全天事件时间设为 00:00
        isAllDay.value ? 0 : currentTime.minute,
      );
      // 如果结束时间早于开始时间，则重置结束时间
      if (endTime.value != null && endTime.value!.isBefore(startTime.value!)) {
        endTime.value = null;
      }
    }
  }

  Future<void> selectStartTime(BuildContext context) async {
    if (startTime.value == null) {
      // 如果没有设置日期，先提示用户选择日期
      Get.snackbar('提示', '请先选择开始日期');
      await selectStartDate(context); // 尝试让用户选择日期
      if (startTime.value == null) return; // 用户仍未选择日期则返回
    }

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(startTime.value!),
    );
    if (pickedTime != null) {
      startTime.value = DateTime(
        startTime.value!.year,
        startTime.value!.month,
        startTime.value!.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      // 如果结束时间早于开始时间，则重置结束时间
       if (endTime.value != null && endTime.value!.isBefore(startTime.value!)) {
         endTime.value = null;
       }
    }
  }

   Future<void> selectEndDate(BuildContext context) async {
     if (startTime.value == null) {
       Get.snackbar('提示', '请先选择开始日期和时间');
       return;
     }
     final DateTime? pickedDate = await showDatePicker(
       context: context,
       initialDate: endTime.value ?? startTime.value!, // 结束日期初始值基于开始日期
       firstDate: startTime.value!, // 结束日期不能早于开始日期
       lastDate: DateTime(2101),
     );
     if (pickedDate != null) {
       final currentTime = endTime.value ?? startTime.value!; // 保留时间或用开始时间
       endTime.value = DateTime(
         pickedDate.year,
         pickedDate.month,
         pickedDate.day,
         isAllDay.value ? 0 : currentTime.hour,
         isAllDay.value ? 0 : currentTime.minute,
       );
     }
   }

   Future<void> selectEndTime(BuildContext context) async {
     if (endTime.value == null) { // 如果结束日期未设置
       if (startTime.value == null) {
          Get.snackbar('提示', '请先选择开始日期和时间');
          return;
       }
       // 提示选择结束日期，或默认使用开始日期
       await selectEndDate(context);
       if (endTime.value == null) return; // 用户未选择结束日期
     }

     final TimeOfDay? pickedTime = await showTimePicker(
       context: context,
       initialTime: TimeOfDay.fromDateTime(endTime.value!),
     );

     if (pickedTime != null) {
       final potentialEndTime = DateTime(
         endTime.value!.year,
         endTime.value!.month,
         endTime.value!.day,
         pickedTime.hour,
         pickedTime.minute,
       );
       // 确保结束时间不早于开始时间
       if (potentialEndTime.isBefore(startTime.value!)) {
         Get.snackbar('错误', '结束时间不能早于开始时间');
       } else {
         endTime.value = potentialEndTime;
       }
     }
   }

  // --- 全天事件切换 ---
  void toggleAllDay(bool value) {
    isAllDay.value = value;
    if (value) {
      // 如果设为全天，将时间设为 00:00
      if (startTime.value != null) {
        startTime.value = DateTime(startTime.value!.year, startTime.value!.month, startTime.value!.day);
      }
      if (endTime.value != null) {
        endTime.value = DateTime(endTime.value!.year, endTime.value!.month, endTime.value!.day);
         // 可选：如果结束日期和开始日期相同，则将结束时间设为 null 或开始时间
         if (endTime.value!.year == startTime.value?.year &&
             endTime.value!.month == startTime.value?.month &&
             endTime.value!.day == startTime.value?.day) {
            // endTime.value = null; // 或者保持日期，时间为 00:00
         }
      }
    } else {
       // 如果取消全天，可以恢复之前的时间或设为当前时间
       // 这里简单处理，用户需要重新选择时间
       // 或者可以保存之前的非全天时间并在取消时恢复
    }
  }


  // --- 保存事件 ---
  Future<void> saveEvent() async {
    if (formKey.currentState!.validate()) { // 触发表单验证
      if (startTime.value == null) {
        Get.snackbar('错误', '请选择开始时间');
        return;
      }

      isSaving.value = true; // 开始保存，显示加载指示

      final newEvent = Event(
        id: const Uuid().v4(), // 生成唯一 ID
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        startTime: startTime.value!,
        endTime: endTime.value, // 可以为 null
        isAllDay: isAllDay.value,
        relatedImagePaths: [], // 初始为空
        tags: [], // 初始为空
        createdAt: DateTime.now(),
        // updatedAt 在 Repository 中处理
        isCompleted: false, // 新事件默认为未完成
      );

      try {
        await _eventRepository.addEvent(newEvent);
        Get.back(); // 保存成功后返回上一页
        Get.snackbar('成功', '事件已添加');
      } catch (e) {
        Get.snackbar('错误', '保存事件失败: $e');
      } finally {
        isSaving.value = false; // 结束保存
      }
    }
  }

  @override
  void onClose() {
    // 清理 Controller
    nameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}