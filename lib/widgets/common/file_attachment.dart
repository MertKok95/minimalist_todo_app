import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_with_getx/controller/todo_controller.dart';

class FileAttachmentWidget extends StatelessWidget {
  final int index;

  final Function()? onAttachmentPressed;

  // ignore: prefer_const_constructors_in_immutables
  FileAttachmentWidget(
      {super.key, required this.index, this.onAttachmentPressed});

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
                color:
                    todoController.todoList.value[index].attachments != null &&
                            todoController
                                .todoList.value[index].attachments!.isNotEmpty
                        ? Colors.blue
                        : Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                todoController.todoList.value[index].attachments != null &&
                        todoController
                            .todoList.value[index].attachments!.isNotEmpty
                    ? todoController.todoList.value[index].attachments!.length
                        .toString()
                    : '',
                style: TextStyle(
                  color: todoController.todoList.value[index].attachments !=
                              null &&
                          todoController
                              .todoList.value[index].attachments!.isNotEmpty
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
