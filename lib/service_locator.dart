import 'package:get_it/get_it.dart';

import 'core/database.dart';
import 'data/data_source/local/to_do_local_data.dart';
import 'data/data_source/remote/auth_remote.dart';
import 'data/data_source/to_do_data_base.dart';
import 'data/repo/auto_repo_impl.dart';
import 'data/repo/to_do_repo_impl.dart';
import 'domain/repo/auth_repo.dart';
import 'domain/repo/to_do_repo.dart';
import 'domain/usecases/auth_usecase.dart';
import 'domain/usecases/to_do_usecase.dart';
import 'presentation/home/provider/get_to_do_list_provider.dart';
import 'services/firebase_service.dart';
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

Future<void> initFirebase() async {
  sl.registerSingleton(FirebaseService());
}

Future<void> setupServiceLocator() async {
  //Auth
  sl.registerLazySingleton<AuthRemoteData>(
    () => AuthRemoteDataImpl(sl.get<FirebaseService>()),
  );
  sl.registerLazySingleton<AuthRepo>(
    () => AutoRepoImpl(sl.get<AuthRemoteData>()),
  );
  sl.registerLazySingleton<AuthUsecase>(() => AuthUsecase(sl.get<AuthRepo>()));

  //To Do
  sl.registerLazySingleton<ToDoData>(
    () =>
        ToDoLocalDataImpl(sl.get<AppDatabase>(), sl.get<NotificationService>()),
  );
  sl.registerLazySingleton<ToDoRepo>(() => ToDoRepoImpl(sl.get<ToDoData>()));
  sl.registerLazySingleton<ToDoUsecase>(() => ToDoUsecase(sl.get<ToDoRepo>()));
  sl.registerLazySingleton<GetToDoListProvider>(
    () => GetToDoListProvider(sl.get<ToDoUsecase>()),
  );
}
