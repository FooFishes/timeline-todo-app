import '../models/event_model.dart';

abstract class IEventRepository {
  // 监听所有事件流 (返回业务模型 Event)
  Stream<List<Event>> watchEvents();

  // 添加事件 (接收业务模型 Event)
  Future<void> addEvent(Event event);

  // 更新事件 (接收业务模型 Event)
  Future<void> updateEvent(Event event);

  // 删除事件
  Future<void> deleteEvent(String id);

  // (可选) 获取单个事件
  Future<Event?> getEventById(String id);
}