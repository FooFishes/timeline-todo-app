import 'package:get/get.dart';
import 'package:timeline_todo_app/database/database.dart';
import 'package:timeline_todo_app/repositories/event_repository.dart';
import 'package:timeline_todo_app/repositories/event_repository_impl.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // 注册数据库单例 (懒加载，第一次使用时创建)
    Get.lazyPut<AppDatabase>(() => AppDatabase(), fenix: true); // fenix: true 保持实例不被销毁

    // 注册 DAO (依赖 AppDatabase)
    Get.lazyPut<EventDao>(() => EventDao(Get.find<AppDatabase>()), fenix: true);

    // 注册 Repository (接口类型，实现类)
    Get.lazyPut<IEventRepository>(() => EventRepositoryImpl(Get.find<EventDao>()), fenix: true);

    // 可以绑定其他全局服务，如网络请求、权限处理等
  }
}