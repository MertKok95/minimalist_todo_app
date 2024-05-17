import 'package:get/get.dart';

import '../app/cache/cache_manager.dart';
import '../app/locator/get_it_locator.dart';
import '../constants/route_constants.dart';
import '../model/user_model.dart';
import '../services/firebase/abstract/abstract_user_service.dart';
import '../viewmodel/sign_in_viewmodel.dart';
import '../viewmodel/user_viewmodel.dart';

class UserController extends GetxController {
  final IUserService _userService = locator<IUserService>();
  Rx<bool> isEnableButton = true.obs;
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

        var model =
            await _userService.createUserWithEmailAndPassword(userModel!);
        if (model != null) {
          await CacheManager.getInstance
              .addCacheItem<UserModel>("UserId", model);
        }
        return model == null ? false : true;
      }
    }
    return false;
  }
}
