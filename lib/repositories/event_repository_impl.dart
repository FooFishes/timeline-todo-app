
import 'package:timeline_todo_app/database/database.dart'; // 引入 Drift 生成的 EventData 和 EventDao
import 'package:timeline_todo_app/models/event_model.dart';
import 'event_repository.dart';
import 'package:drift/drift.dart';

class EventRepositoryImpl implements IEventRepository {
  final EventDao _eventDao; // 依赖注入 EventDao

  EventRepositoryImpl(this._eventDao);

  // --- Drift Data Class (EventData) <--> Business Model (Event) 转换 ---
  // 从 EventData 转换为 Event
  Event _mapEventDataToEvent(EventData data) {
    return Event(
      id: data.id,
      name: data.name,
      description: data.description,
      startTime: data.startTime,
      endTime: data.endTime,
      isAllDay: data.isAllDay,
      relatedImagePaths: data.relatedImagePaths, // TypeConverter 已处理 List<String>
      tags: data.tags, // TypeConverter 已处理 List<String>
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      isCompleted: data.isCompleted,
    );
  }

  // 从 Event 转换为 Drift 的 Companion (用于插入/更新)
  EventsCompanion _mapEventToCompanion(Event event) {
    // 使用 Companion 可以只更新变化的字段，或插入新数据
    return EventsCompanion(
      id: Value(event.id),
      name: Value(event.name),
      description: Value(event.description), // Value.absent() 表示不更新或使用默认值
      startTime: Value(event.startTime),
      endTime: Value(event.endTime),
      isAllDay: Value(event.isAllDay),
      relatedImagePaths: Value(event.relatedImagePaths),
      tags: Value(event.tags),
      createdAt: Value(event.createdAt),
      updatedAt: Value(event.updatedAt ?? DateTime.now()), // 更新时设置 updatedAt
      isCompleted: Value(event.isCompleted),
    );
  }
  // --- 实现接口方法 ---

  @override
  Stream<List<Event>> watchEvents() {
    // 监听 DAO 的 Stream<List<EventData>> 并映射为 Stream<List<Event>>
    return _eventDao.watchAllEventsSorted().map((listData) =>
        listData.map(_mapEventDataToEvent).toList()
    );
  }

  @override
  Future<void> addEvent(Event event) async {
    // 将 Event 转换为 EventsCompanion 并插入
    // 确保 createdAt 和 updatedAt 在这里或 Event.createNew 中正确设置
    final companion = _mapEventToCompanion(event.copyWith(
        updatedAt: event.createdAt // 创建时 updatedAt 等于 createdAt
    ));
    await _eventDao.insertEvent(companion);
  }

  @override
  Future<void> updateEvent(Event event) async {
    // 将 Event 转换为 EventsCompanion 并更新
    final companion = _mapEventToCompanion(event.copyWith(
        updatedAt: DateTime.now() // 更新时设置当前时间
    ));
    await _eventDao.updateEvent(companion);
  }

  @override
  Future<void> deleteEvent(String id) async {
    await _eventDao.deleteEvent(id);
  }

  @override
  Future<Event?> getEventById(String id) async {
    final eventData = await _eventDao.getEventById(id);
    return eventData != null ? _mapEventDataToEvent(eventData) : null;
  }
}