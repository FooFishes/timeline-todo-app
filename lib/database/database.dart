// 这是一个简单的 Drift 数据库实现，包含了事件表和相关的 DAO
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:freezed_annotation/freezed_annotation.dart'; // 只是为了类型提示，实际不依赖
import 'package:timeline_todo_app/models/event_model.dart'; 
import 'type_converter.dart';

part 'database.g.dart'; 

// --- 1. 定义 Drift 表 ---
// 表名通常是复数形式
@DataClassName('EventData') // Drift 生成的数据类名，避免与你的模型冲突
class Events extends Table {
  // 主键，对应 Event.id
  TextColumn get id => text()();
  // 对应 Event.name
  TextColumn get name => text()();
  // 对应 Event.description (可空)
  TextColumn get description => text().nullable()();
  // 对应 Event.startTime
  DateTimeColumn get startTime => dateTime()();
  // 对应 Event.endTime (可空)
  DateTimeColumn get endTime => dateTime().nullable()();
  // 对应 Event.isAllDay
  BoolColumn get isAllDay => boolean()();
  // 对应 Event.relatedImagePaths, 使用自定义类型转换器
  TextColumn get relatedImagePaths => text().map(const ListStringConverter()).withDefault(const Constant(''))();
  // 对应 Event.tags, 使用自定义类型转换器
  TextColumn get tags => text().map(const ListStringConverter()).withDefault(const Constant(''))();
  // 对应 Event.createdAt
  DateTimeColumn get createdAt => dateTime()();
  // 对应 Event.updatedAt (可空)
  DateTimeColumn get updatedAt => dateTime().nullable()();
  // 对应 Event.isCompleted
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id}; // 设置主键
}


// --- 2. 定义 DAO (Data Access Object) ---
@DriftAccessor(tables: [Events])
class EventDao extends DatabaseAccessor<AppDatabase> with _$EventDaoMixin {
  // AppDatabase 会通过构造函数注入
  EventDao(AppDatabase db) : super(db);

  // 监听所有事件 (返回 Stream，实现响应式)
  Stream<List<EventData>> watchAllEvents() => select(events).watch();

  // 按创建时间降序监听所有事件
   Stream<List<EventData>> watchAllEventsSorted() {
    return (select(events)..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)])).watch();
  }

  // 获取单个事件
  Future<EventData?> getEventById(String id) =>
      (select(events)..where((t) => t.id.equals(id))).getSingleOrNull();

  // 插入新事件 (传入 Drift 生成的 EventData 类)
  Future<int> insertEvent(Insertable<EventData> event) =>
      into(events).insert(event);

  // 更新事件 (传入 Drift 生成的 EventData 类)
  Future<bool> updateEvent(Insertable<EventData> event) =>
      update(events).replace(event);

  // 删除事件
  Future<int> deleteEvent(String id) =>
      (delete(events)..where((t) => t.id.equals(id))).go();

  // (可选) 插入或更新事件
  Future<void> upsertEvent(Insertable<EventData> event) =>
      into(events).insertOnConflictUpdate(event);

   // --- 数据库模型到业务模型的转换 ---
   // 注意：更推荐在 Repository 层做这个转换
   // 但如果简单，放 DAO 也可以，或者提供转换后的 Stream
   Stream<List<Event>> watchAllBusinessEventsSorted() {
     return watchAllEventsSorted().map((eventDataList) =>
       eventDataList.map((data) => _mapEventDataToEvent(data)).toList()
     );
   }

   Event _mapEventDataToEvent(EventData data) {
        return Event(
            id: data.id,
            name: data.name,
            description: data.description,
            startTime: data.startTime,
            endTime: data.endTime,
            isAllDay: data.isAllDay,
            relatedImagePaths: data.relatedImagePaths,
            tags: data.tags,
            createdAt: data.createdAt,
            updatedAt: data.updatedAt,
            isCompleted: data.isCompleted,
        );
    }
}


// --- 3. 定义数据库 ---
@DriftDatabase(tables: [Events], daos: [EventDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // AppDatabase(QueryExecutor e) : super(e); // 用于测试

  @override
  int get schemaVersion => 1; // 数据库版本

  // --- (可选) 数据迁移策略 ---
  // @override
  // MigrationStrategy get migration => MigrationStrategy(
  //   onCreate: (Migrator m) async {
  //     await m.createAll();
  //   },
  //   onUpgrade: (Migrator m, int from, int to) async {
  //     if (from == 1) {
  //       // 例如，如果从版本 1 升级到版本 2，添加了一个新列
  //       // await m.addColumn(events, events.newColumn);
  //     }
  //   },
  // );
}

// --- 数据库连接 ---
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

// --- 提供单例 ---
// 可以使用 GetX 来管理单例，或者简单的全局变量
final AppDatabase database = AppDatabase(); 