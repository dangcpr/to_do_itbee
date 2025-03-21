import 'package:get_it/get_it.dart';

import 'core/database.dart';
import 'data/data_source/local/to_do_local_data.dart';
import 'data/repo/to_do_repo_impl.dart';
import 'domain/repo/to_do_repo.dart';
import 'domain/usecases/to_do_usecase.dart';
import 'presentation/home/provider/get_to_do_list_provider.dart';
import 'services/notification_service.dart';

final sl = GetIt.instance;

Future<void> initDb() async {
  sl.registerSingleton<AppDatabase>(AppDatabase());
  await sl.get<AppDatabase>().initDb();
}

Future<void> initLocalNoti() async {
  sl.registerSingleton<NotificationService>(NotificationService());
  await sl.get<NotificationService>().initialize();
}

Future<void> setupServiceLocator() async {
  sl.registerSingleton<ToDoLocalData>(
    ToDoLocalDataImpl(sl.get<AppDatabase>(), sl.get<NotificationService>()),
  );
  sl.registerSingleton<ToDoRepo>(ToDoRepoImpl(sl.get<ToDoLocalData>()));
  sl.registerSingleton<ToDoUsecase>(ToDoUsecase(sl.get<ToDoRepo>()));
  sl.registerSingleton<GetToDoListProvider>(
    GetToDoListProvider(sl.get<ToDoUsecase>()),
  );
}
