import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/todo_controller.dart';
import '../common/file_attachment.dart';

// ignore: must_be_immutable
class CustomRowItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  bool isConfirmed;
  final String itemKey;
  final Function()? onAttachmentPressed;
  final todoController = Get.find<TodoController>();

  // ignore: use_key_in_widget_constructors
  CustomRowItem({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.itemKey,
    this.isConfirmed = false,
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
                value: todoController.selectedItems.value
                        .any((key) => key == itemKey)
                    ? true
                    : false,
                onChanged: (value) {
                  todoController.selectTodoItem(itemKey, value);
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
          FileAttachmentWidget(
              itemKey: itemKey, onAttachmentPressed: onAttachmentPressed)
        ],
      ),
    );
  }
}
