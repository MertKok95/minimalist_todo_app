import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_with_getx/controller/todo_controller.dart';

class FileAttachmentWidget extends StatelessWidget {
  final Function()? onAttachmentPressed;

  // ignore: prefer_const_constructors_in_immutables
  FileAttachmentWidget({super.key, this.onAttachmentPressed});

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
                color: todoController.hasAttachment.value
                    ? Colors.blue
                    : Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                todoController.hasAttachment.value
                    ? todoController.pickedFiles.value.length.toString()
                    : '',
                style: TextStyle(
                  color: todoController.hasAttachment.value
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
