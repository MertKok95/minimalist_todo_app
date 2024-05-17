import 'base_model.dart';

class TagModel extends IBaseModel<TagModel> {
  int? key;
  String? value;

  TagModel({
    this.key,
    this.value,
  });

  @override
  TagModel fromJson(Map<String, dynamic> json) {
    return TagModel(
      key: json["key"],
      value: json["value"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "key": key,
      "value": value,
    };
  }
}
