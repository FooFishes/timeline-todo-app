import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart'; // 用于生成 ID

part 'event_model.freezed.dart';
part 'event_model.g.dart';

@freezed
class Event with _$Event {
  const factory Event({
    required String id,
    required String name,
    String? description,
    required DateTime startTime,
    DateTime? endTime,
    required bool isAllDay,
    @Default([]) List<String> relatedImagePaths, // 本地版本存储本地文件路径
    @Default([]) List<String> tags,
    required DateTime createdAt,
    DateTime? updatedAt,
    @Default(false) bool isCompleted,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  // 辅助方法，方便创建新事件时自动生成 ID 和 createdAt
  factory Event.createNew({
     required String name,
     String? description,
     required DateTime startTime,
     DateTime? endTime,
     required bool isAllDay,
     List<String>? relatedImagePaths,
     List<String>? tags,
     bool isCompleted = false,
  }) {
    final now = DateTime.now();
    return Event(
      id: Uuid().v4(), // 自动生成 UUID
      name: name,
      description: description,
      startTime: startTime,
      endTime: endTime,
      isAllDay: isAllDay,
      relatedImagePaths: relatedImagePaths ?? [],
      tags: tags ?? [],
      createdAt: now,
      updatedAt: now, // 创建时 updatedAt 等于 createdAt
      isCompleted: isCompleted,
    );
  }
}