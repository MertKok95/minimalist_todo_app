import 'package:todo_list_with_getx/model/user_model.dart';
import 'package:todo_list_with_getx/viewmodel/user_viewmodel.dart';

import '../../../viewmodel/sign_in_viewmodel.dart';

abstract class IUserService {
  Future<UserModel?> signIn(SignInViewModel model);
  Future<void> signOut();
  Future<bool> createUserWithEmailAndPassword(UserModel model);
}
