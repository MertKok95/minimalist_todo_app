// To parse this JSON data, do
//
//     final userSaveTodoViewModel = userSaveTodoViewModelFromJson(jsonString);

import 'dart:io';

import 'package:todo_list_with_getx/model/tag_model.dart';

class UserSaveTodoViewModel {
  String title;
  String note;
  int priority;
  DateTime dueDate;
  String category;
  List<TagModel> tags;
  bool isCompleted;

  List<File>? attachments;

  UserSaveTodoViewModel({
    required this.title,
    required this.note,
    required this.priority,
    required this.dueDate,
    required this.category,
    this.isCompleted = false,
    required this.tags,
    this.attachments,
  });

  factory UserSaveTodoViewModel.fromJson(Map<String, dynamic> json) =>
      UserSaveTodoViewModel(
        title: json["title"],
        note: json["note"],
        priority: json["priority"],
        dueDate: DateTime.parse(json["dueDate"]),
        isCompleted: json["isCompleted"],
        category: json["category"],
        tags: List<TagModel>.from(
            json["tags"].map((x) => TagModel().fromJson(x))),
        attachments: List<File>.from(json["attachments"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "note": note,
        "priority": priority,
        "dueDate": dueDate.toIso8601String(),
        "category": category,
        'isCompleted': isCompleted,
        'tags':
            List<Map<String, dynamic>>.from(tags.map((tag) => tag.toJson())),
        "attachments": attachments != null
            ? List<File>.from(attachments!.map((x) => x))
            : "[]",
      };
}
