import 'base_model.dart';

class Status extends IBaseModel<Status> {
  String? key;
  String? value;

  Status({
    this.key,
    this.value,
  });

  @override
  Status fromJson(Map<String, dynamic> json) {
    return Status(
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
