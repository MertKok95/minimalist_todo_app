import 'base_model.dart';
import 'category_model.dart';
import 'priority_model.dart';
import 'tag_model.dart';

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
      dueDate: json["dueDate"],
      // dueDate: json['dueDate'] != null
      //     ? DateTime.parse(json['dueDate'])
      //     : DateTime.now().add(
      //         const Duration(days: 30)), // if no deadline, default value is 30
      category: json["category"] != null
          ? CategoryModel().fromJson(json["category"])
          : CategoryModel(),
      attachments: json["attachments"] == null
          ? []
          : List<String>.from(json["attachments"]!.map((x) => x)),
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
      'category':
          category != null ? category!.toJson() : CategoryModel().toJson(),
      "tags": List<Map<String, dynamic>>.from(tags!.map((x) => x.toJson())),
      "attachments": attachments != null
          ? List<String>.from(attachments!.map((file) => file))
          : "[]",
    };
  }
}
