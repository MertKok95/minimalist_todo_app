import 'package:get_it/get_it.dart';

import '../../services/firebase/abstract/abstract_todo_service.dart';
import '../../services/firebase/abstract/abstract_user_service.dart';
import '../../services/firebase/concrete/todo_service.dart';
import '../../services/firebase/concrete/user_service.dart';

final locator = GetIt.instance;

void setUpLocator() {
  // User Service
  locator.registerLazySingleton<IUserService>(() => UserService());

  // Todo Service
  locator.registerLazySingleton<ITodoService>(() => TodoService());
}
