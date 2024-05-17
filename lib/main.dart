import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:todo_list_with_getx/app/locator/get_it_locator.dart';
import 'package:todo_list_with_getx/constants/route_constants.dart';
import 'package:todo_list_with_getx/screens/main_screen.dart';
import 'package:todo_list_with_getx/screens/sign_in_screen.dart';
import 'package:todo_list_with_getx/screens/sign_up_screen.dart';

import 'app/cache/cache_manager.dart';
import 'app/helper/notification_helper.dart';
import 'firebase_options.dart';
import 'screens/create_todo_screen.dart';

// service tarafı yapılacak - getit kütüphanesi kullanılacak
// appBar widget olarak tasarlanacak
// detay eklemeleri için onay buttonları eklenecek.
// category seçilmediği halde ilk değeri ekliyor, çözülecek.
// message sistemi aktif hale gelecek
// kullanıcı todo öncelik sıralaması yapılacak
// notification - bildirim sistemi yapılacak
// profile resmi yükleme yapılacak
// bütün sabit yazılar, farklı bir sınıfa taşınacak ve oradan çağırılacak
// minimizasyon için bakılacak
// klavye sorunu için inceleme yapılacak - simülatör kaynaklık mı kod kaynaklı mı ?
// birden fazla tıklama engellenecek
// notification detay kısmı halledilecek.
// todo service yapılacak

void main() {
  setInitialize();
  // locator gelecek
  runApp(TodoListApp());
}

setInitialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUpLocator();
  CacheManager.getInstance;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationHelper.init();
}

class TodoListApp extends StatelessWidget {
  final getScreens = [
    GetPage(name: RouteConstants.signInScreen, page: () => SignInScreen()),
    GetPage(name: RouteConstants.signUpScreen, page: () => SignUpScreen()),
    GetPage(name: RouteConstants.mainScreen, page: () => MainScreen()),
    GetPage(
        name: RouteConstants.createTodoScreen, page: () => CreateTodoScreen()),
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
