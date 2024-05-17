import '../../../model/user_model.dart';
import '../../../viewmodel/sign_in_viewmodel.dart';

abstract class IUserService {
  Future<UserModel?> signIn(SignInViewModel model);
  Future<void> signOut();
  Future<UserModel?> createUserWithEmailAndPassword(UserModel model);
}
