import 'package:todo_list_with_getx/model/base_model.dart';

class CategoryModel extends IBaseModel<CategoryModel> {
  int? key;
  String? value;

  CategoryModel({
    this.key,
    this.value,
  });

  @override
  CategoryModel fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      key: json["Key"],
      value: json["Value"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "Key": key,
      "Value": value,
    };
  }
}