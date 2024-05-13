// ignore_for_file: prefer_const_constructors_in_immutables

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_with_getx/widgets/common/file_attachment.dart';

import '../../controller/todo_controller.dart';

class CustomRowItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  bool isConfirmed;
  final bool hasAttachment;
  final int index;
  final Function()? onAttachmentPressed;
  final todoController = Get.find<TodoController>();

  CustomRowItem({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.index,
    this.isConfirmed = false,
    this.hasAttachment = false,
    this.onAttachmentPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(5),
      color: Colors.white,
      child: Row(
        children: [
          Obx(
            () => Checkbox(
                value: todoController.todoList.value[index].isCompleted,
                onChanged: (value) {
                  todoController.selectTodoItem(index, value);
                }),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          FileAttachmentWidget(onAttachmentPressed: onAttachmentPressed)
        ],
      ),
    );
  }
}
