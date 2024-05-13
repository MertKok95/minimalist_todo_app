import 'dart:io';

import 'package:todo_list_with_getx/model/base_model.dart';
import 'package:todo_list_with_getx/model/category_model.dart';
import 'package:todo_list_with_getx/model/tag_model.dart';

import 'priority_model.dart';

class TodoModel extends IBaseModel<TodoModel> {
  String? uid;
  String? key;
  String? title;
  String? note;
  PriorityModel? priority;
  String? dueDate;
  CategoryModel? category;
  List<TagModel>? tags;
  List<String>? attachments;
  late bool isCompleted;

  TodoModel(
      {this.uid,
      this.key,
      this.title,
      this.note,
      this.priority,
      this.dueDate,
      this.category,
      this.tags,
      this.attachments,
      this.isCompleted = false});

  @override
  TodoModel fromJson(Map<String, dynamic> json) {
    return TodoModel(
      uid: json['uid'],
      key: json['key'],
      title: json['title'],
      note: json['note'],
      priority: PriorityModel().fromJson(json["priority"]),
      isCompleted: json["isCompleted"],
      dueDate: json["date"],
      // dueDate: json['dueDate'] != null
      //     ? DateTime.parse(json['dueDate'])
      //     : DateTime.now().add(
      //         const Duration(days: 30)), // if no deadline, default value is 30
      category: CategoryModel().fromJson(json["category"]),
      tags: json["tags"] == null
          ? []
          : List<TagModel>.from(
              json["tags"]!.map((x) => TagModel().fromJson(x))),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'key': key,
      'title': title,
      'note': note,
      'priority': priority!.toJson(),
      'isCompleted': isCompleted,
      'dueDate': dueDate,
      // 'dueDate': dueDate!.toIso8601String(),
      'category': category!.toJson(),
      "tags": List<Map<String, dynamic>>.from(tags!.map((x) => x.toJson())),
      "attachments": attachments != null
          ? List<String>.from(attachments!.map((file) => file))
          : "[]",
    };
  }
}
