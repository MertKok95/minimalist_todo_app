import 'base_model.dart';

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
      key: json["Key"] ?? 0,
      value: json["Value"] ?? "",
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "Key": key ?? 0,
      "Value": value ?? "",
    };
  }
}
