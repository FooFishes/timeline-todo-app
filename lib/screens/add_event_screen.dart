import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For date/time formatting
import 'package:timeline_todo_app/controllers/add_event_controller.dart';

class AddEventScreen extends GetView<AddEventController> {
  const AddEventScreen({super.key});

  // Helper to format DateTime or return a placeholder
  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '未选择';
    // Consider locale if needed
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return '未选择';
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '未选择';
    return DateFormat('HH:mm').format(dateTime);
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('添加新事件'),
        actions: [
          Obx(() => controller.isSaving.value
