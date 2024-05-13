import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:todo_list_with_getx/constants/route_constants.dart';
import 'package:todo_list_with_getx/screens/main_screen.dart';
import 'package:todo_list_with_getx/screens/sign_in_screen.dart';
import 'package:todo_list_with_getx/screens/sign_up_screen.dart';

import 'app/cache/cache_manager.dart';
import 'firebase_options.dart';

void main() {
  setInitialize();
  runApp(TodoListApp());
}

setInitialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  CacheManager.getInstance;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class TodoListApp extends StatelessWidget {
  final getScreens = [
    GetPage(name: RouteConstants.mainScreen, page: () => MainScreen()),
    GetPage(name: RouteConstants.signInScreen, page: () => SignInScreen()),
    GetPage(name: RouteConstants.signUpScreen, page: () => SignUpScreen()),
  ];

  TodoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: RouteConstants.signInScreen,
      getPages: getScreens,
    );
  }
}
