import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/todo_controller.dart';

class FileAttachmentWidget extends StatelessWidget {
  final String itemKey;
  final Function()? onAttachmentPressed;

  // ignore: prefer_const_constructors_in_immutables
  FileAttachmentWidget(
      {super.key, required this.itemKey, this.onAttachmentPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onAttachmentPressed,
      child: GetX<TodoController>(
        builder: (todoController) {
          return Row(
            children: [
              Icon(
                Icons.attach_file,
                color: todoController.todoList.value
                        .where((element) => element.key == itemKey)
                        .first
                        .attachments!
                        .isNotEmpty
                    ? Colors.blue
                    : Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                todoController.todoList.value
                        .where((element) => element.key == itemKey)
                        .first
                        .attachments!
                        .isNotEmpty
                    ? todoController.todoList.value
                        .where((element) => element.key == itemKey)
                        .first
                        .attachments!
                        .length
                        .toString()
                    : '',
                style: TextStyle(
                  color: todoController.todoList.value
                          .where((element) => element.key == itemKey)
                          .first
                          .attachments!
                          .isNotEmpty
                      ? Colors.blue
                      : Colors.grey,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
