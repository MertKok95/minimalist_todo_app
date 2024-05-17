import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/string_constants.dart';
import '../../controller/todo_controller.dart';
import 'bottom_sheet.dart';

class DetailButton extends StatelessWidget {
  final todoController = Get.find<TodoController>();

  DetailButton({super.key});

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
            side: const BorderSide(color: Colors.grey),
          ),
        ),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return BottomSheetWidget();
              });
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          child: Text(
            StringConstants.todoDetail,
            style: TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
