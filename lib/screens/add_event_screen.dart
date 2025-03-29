import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeline_todo_app/controllers/add_event_controller.dart';
import 'package:intl/intl.dart';

class AddEventScreen extends GetView<AddEventController> {
  const AddEventScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('添加新事件'),
        centerTitle: false,
        actions: [
          Obx(() => controller.isSaving.value
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    height: 24, 
                    width: 24, 
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  ),
                ),
              )
            : TextButton.icon(
                onPressed: controller.saveEvent,
                icon: const Icon(Icons.check),
                label: const Text('保存'),
              ),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 事件名称
                TextFormField(
                  controller: controller.nameController,
                  decoration: const InputDecoration(
                    labelText: '事件名称',
                    hintText: '输入事件名称',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.event),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '请输入事件名称';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                // 全天事件开关
                Card(
                  margin: EdgeInsets.zero,
                  elevation: 0,
                  color: colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: Obx(() => SwitchListTile(
                      title: const Text('全天事件'),
                      secondary: Icon(
                        Icons.today,
                        color: colorScheme.primary,
                      ),
                      value: controller.isAllDay.value,
                      onChanged: controller.toggleAllDay,
                      activeColor: colorScheme.primary,
                    )),
                  ),
                ),
                const SizedBox(height: 20),
                
                // 日期时间选择
                Text(
                  '时间',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                
                // 开始时间
                Card(
                  margin: EdgeInsets.zero,
                  elevation: 0,
                  color: colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  child: Column(
                    children: [
                      // 开始日期
                      Obx(() => ListTile(
                        leading: Icon(Icons.calendar_today, color: colorScheme.primary),
                        title: const Text('开始日期'),
                        subtitle: Text(
                          controller.startTime.value != null
                              ? DateFormat('yyyy年MM月dd日').format(controller.startTime.value!)
                              : '未设置',
                          style: TextStyle(
                            color: controller.startTime.value != null
                                ? colorScheme.onSurface
                                : colorScheme.outline,
                          ),
                        ),
                        onTap: () => controller.selectStartDate(context),
                      )),
                      
                      // 仅当非全天事件时显示时间选择
                      Obx(() => !controller.isAllDay.value
                        ? Column(
                            children: [
                              const Divider(indent: 72, height: 1),
                              ListTile(
                                leading: Icon(Icons.access_time, color: colorScheme.primary),
                                title: const Text('开始时间'),
                                subtitle: Text(
                                  controller.startTime.value != null
                                      ? DateFormat('HH:mm').format(controller.startTime.value!)
                                      : '未设置',
                                  style: TextStyle(
                                    color: controller.startTime.value != null
                                        ? colorScheme.onSurface
                                        : colorScheme.outline,
                                  ),
                                ),
                                onTap: () => controller.selectStartTime(context),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // 结束时间
                Card(
                  margin: EdgeInsets.zero,
                  elevation: 0,
                  color: colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  child: Column(
                    children: [
                      // 结束日期
                      Obx(() => ListTile(
                        leading: Icon(Icons.event_busy, color: colorScheme.primary),
                        title: const Text('结束日期'),
                        subtitle: Text(
                          controller.endTime.value != null
                              ? DateFormat('yyyy年MM月dd日').format(controller.endTime.value!)
                              : '未设置',
                          style: TextStyle(
                            color: controller.endTime.value != null
                                ? colorScheme.onSurface
                                : colorScheme.outline,
                          ),
                        ),
                        onTap: () => controller.selectEndDate(context),
                      )),
                      
                      // 仅当非全天事件时显示时间选择
                      Obx(() => !controller.isAllDay.value
                        ? Column(
                            children: [
                              const Divider(indent: 72, height: 1),
                              ListTile(
                                leading: Icon(Icons.access_alarm, color: colorScheme.primary),
                                title: const Text('结束时间'),
                                subtitle: Text(
                                  controller.endTime.value != null
                                      ? DateFormat('HH:mm').format(controller.endTime.value!)
                                      : '未设置',
                                  style: TextStyle(
                                    color: controller.endTime.value != null
                                        ? colorScheme.onSurface
                                        : colorScheme.outline,
                                  ),
                                ),
                                onTap: () => controller.selectEndTime(context),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // 事件描述
                TextFormField(
                  controller: controller.descriptionController,
                  decoration: const InputDecoration(
                    labelText: '事件描述',
                    hintText: '添加详细描述（可选）',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.description),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 5,
                  minLines: 3,
                ),
                
                const SizedBox(height: 32),
                
                // 保存按钮
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Obx(() => FilledButton.icon(
                    onPressed: controller.isSaving.value ? null : controller.saveEvent,
                    icon: controller.isSaving.value 
                      ? Container(
                          width: 24,
                          height: 24,
                          padding: const EdgeInsets.all(2.0),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Icon(Icons.save),
                    label: Text(
                      controller.isSaving.value ? '保存中...' : '保存事件',
                      style: const TextStyle(fontSize: 16),
                    ),
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}