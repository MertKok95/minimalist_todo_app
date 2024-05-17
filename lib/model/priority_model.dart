import 'base_model.dart';

class PriorityModel extends IBaseModel<PriorityModel> {
  int? key;
  String? value;

  PriorityModel({
    this.key,
    this.value,
  });

  @override
  PriorityModel fromJson(Map<String, dynamic> json) {
    return PriorityModel(
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
