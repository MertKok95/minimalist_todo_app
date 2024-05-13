import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:todo_list_with_getx/constants/route_constants.dart';
import 'package:todo_list_with_getx/model/user_model.dart';
import 'package:todo_list_with_getx/viewmodel/sign_in_viewmodel.dart';

import '../app/cache/cache_manager.dart';
import '../viewmodel/user_viewmodel.dart';

class UserController extends GetxController {
  UserModel? userModel;

  UserController() {
    userModel ??= UserModel();
  }

  Future signIn(SignInViewModel model) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: model.email, password: model.password);
      var uid = credential.user!.uid;

      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot user =
          await firestore.collection("users").doc(uid).get();
      String name = user["name"];
      String surname = user["surname"];
      String email = user["email"];

      UserModel userModel =
          UserModel(uid: uid, name: name, surname: surname, email: email);
      var userJsonModel = UserModel().fromJson(userModel.toJson());

      CacheManager.getInstance.addCacheItem<UserModel>("UserId", userJsonModel);
      Get.offNamedUntil(RouteConstants.mainScreen, (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  saveUser(UserViewModel? userViewModel) async {
    if (userViewModel != null) {
      if (userViewModel.password == userViewModel.rePassword) {
        userModel!.name = userViewModel.name;
        userModel!.surname = userViewModel.surname;
        userModel!.email = userViewModel.email;
        userModel!.password = userViewModel.password;

        FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: userModel!.email!, password: userModel!.password!)
            .then((response) async {
          userModel!.uid = response.user!.uid;

          await saveUserToFirestore(userModel!);
          Get.offNamedUntil(RouteConstants.mainScreen, (route) => false);
        });
      }
    }
  }

  saveUserToFirestore(UserModel userModel) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userModel.uid)
        .set(userModel.toJson());
  }
}
