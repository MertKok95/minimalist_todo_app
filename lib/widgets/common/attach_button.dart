// ignore_for_file: must_be_immutable

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/todo_controller.dart';

class AttachButton extends StatelessWidget {
  final todoController = Get.find<TodoController>();
  late Function() onPressed;

  pickFiles() async {
    var result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'xls', 'xlsx', 'doc', 'docx']);
    todoController.addAttachmentToTask(result != null ? result.files : []);
  }

  AttachButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Ekran genişliğine göre genişlik

      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[100], // Beyaza yakın gri renk
          disabledBackgroundColor: Colors.grey[100],
          disabledForegroundColor: Colors.grey[100],
          foregroundColor: Colors.black26,
          surfaceTintColor: Colors.grey[100],
          elevation: 5.0, // Gölge yüksekliği d
          shadowColor: Colors.black26, // Gölge rengi
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: Colors.grey),
          ),
        ),
        onPressed: () async => pickFiles(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          child: GetX<TodoController>(builder: (todoController) {
            return Row(
              children: [
                Text(
                  'Dosya Seç',
                  style: TextStyle(color: Colors.black),
                ),
                Spacer(),

                Text(
                  todoController.hasAttachment.value
                      ? todoController.pickedFiles.value.length.toString()
                      : "none",
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(width: 4.0), // 'none' yazısı ve ikon arasında boşluk
                Icon(
                  Icons.attach_file,
                  color: todoController.hasAttachment.value
                      ? Colors.blue
                      : Colors.grey,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
