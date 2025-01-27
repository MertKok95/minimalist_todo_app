import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../model/user_model.dart';
import '../../../viewmodel/sign_in_viewmodel.dart';
import '../abstract/abstract_user_service.dart';

class UserService extends IUserService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<UserModel?> createUserWithEmailAndPassword(UserModel model) async {
    try {
      var response = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: model.email!, password: model.password!);
      model.uid = response.user!.uid;
      await saveUserToFirestore(model);
      return model;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserModel?> signIn(SignInViewModel model) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: model.email, password: model.password);
      var uid = credential.user!.uid;

      DocumentSnapshot<Map<String, dynamic>> user =
          await firestore.collection("users").doc(uid).get();

      return UserModel().fromJson(user.data()!);
    } on FirebaseAuthException catch (e) {
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  saveUserToFirestore(UserModel userModel) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userModel.uid)
        .set(userModel.toJson());
  }
}
