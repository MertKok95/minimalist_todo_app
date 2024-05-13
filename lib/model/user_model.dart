import 'base_model.dart';

class UserModel extends IBaseModel<UserModel> {
  String? uid;
  String? name;
  String? surname;
  String? email;
  String? password;

  UserModel({this.uid, this.name, this.surname, this.email, this.password});

  @override
  UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
        uid: json['uid'],
        name: json['name'],
        surname: json["surname"],
        email: json['email'],
        password: json["password"]);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'surname': surname,
      'email': email,
      'password': password
    };
  }
}
