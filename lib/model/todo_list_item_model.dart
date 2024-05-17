import 'base_model.dart';

class TodoListItemModel extends IBaseModel<TodoListItemModel> {
  String title;
  String subTitle;
  DateTime date;
  bool isConfirmed;

  TodoListItemModel({
    required this.title,
    required this.subTitle,
    required this.date,
    required this.isConfirmed,
  });

  TodoListItemModel fromJson(Map<String, dynamic> json) => TodoListItemModel(
        title: json["title"],
        subTitle: json["subTitle"],
        date: DateTime.parse(json["date"]),
        isConfirmed: json["isConfirmed"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "subTitle": subTitle,
        "date": date.toIso8601String(),
        "isConfirmed": isConfirmed,
      };
}
