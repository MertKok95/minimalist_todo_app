import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:todo_list_with_getx/app/helper/message_helper.dart';
import 'package:todo_list_with_getx/constants/route_constants.dart';
import 'package:todo_list_with_getx/model/user_model.dart';
import 'package:todo_list_with_getx/services/firebase/abstract/abstract_user_service.dart';
import 'package:todo_list_with_getx/viewmodel/sign_in_viewmodel.dart';

import '../app/cache/cache_manager.dart';
import '../app/locator/get_it_locator.dart';
import '../viewmodel/user_viewmodel.dart';

class UserController extends GetxController {
  final IUserService _userService = locator<IUserService>();
  UserModel? userModel;

  UserController() {
    userModel ??= UserModel();
  }

  Future signIn(SignInViewModel? model) async {
    if (model != null) {
      var user = await _userService.signIn(model);

      if (user != null) {
        CacheManager.getInstance.addCacheItem<UserModel>("UserId", user);
        Get.offNamedUntil(RouteConstants.mainScreen, (route) => false);
      }
    }
  }

  Future signOut() async {
    _userService.signOut();
  }

  Future<bool> saveUser(UserViewModel? userViewModel) async {
    if (userViewModel != null) {
      if (userViewModel.password == userViewModel.rePassword) {
        userModel!.name = userViewModel.name;
        userModel!.surname = userViewModel.surname;
        userModel!.email = userViewModel.email;
        userModel!.password = userViewModel.password;

        var response =
            await _userService.createUserWithEmailAndPassword(userModel!);
        return response ? true : false;
      }
    }
    return false;
  }
}
