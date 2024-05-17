import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_select/flutter_awesome_select.dart';
import 'package:get/get.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

import '../../controller/todo_controller.dart';
import '../common/attach_button.dart';

class BottomSheetWidget extends StatelessWidget {
  final todoController = Get.find<TodoController>();

  BottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      todoController.cancelTodoDetails();
                      Navigator.of(context).pop();
                    },
                    child: Text('İptal Et'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ekle'),
                  ),
                  // FileAttachmentWidget(
                  //   onAttachmentPressed: pickFiles,
                  // )
                ],
              ),
              const SizedBox(height: 16),
              const Text('Kategori', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              CustomDropdown<String>(
                hintText: 'Kategori Seç',
                items: todoController.categoryList.value
                    .map((data) => data.value!)
                    .toList(),
                initialItem: todoController.categoryList.value[0].value,
                decoration:
                    CustomDropdownDecoration(closedFillColor: Colors.grey[200]),
                onChanged: (value) => todoController.setCategory(value),
              ),
              const SizedBox(height: 10),
              AttachButton(onPressed: () {}),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Teslim Tarihi', style: TextStyle(fontSize: 18)),
                  TimePickerSpinnerPopUp(
                    mode: CupertinoDatePickerMode.dateAndTime,
                    initTime: DateTime.now(),
                    minTime: DateTime.now().subtract(const Duration(days: 10)),
                    maxTime: DateTime.now().add(const Duration(days: 180)),
                    barrierColor:
                        Colors.black12, //Barrier Color when pop up show
                    minuteInterval: 1,
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    cancelText: 'İptal Et',
                    confirmText: 'Onayla',
                    pressType: PressType.singlePress,
                    timeFormat: 'dd/MM/yyyy',
                    onChange: (dateTime) {
                      todoController.date.value = dateTime.toIso8601String();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(
                color: Colors.black,
                height: 20,
                thickness: 2,
              ),
              SmartSelect<int>.multiple(
                title: 'Etiket Seç',
                placeholder: 'Etiketler',
                selectedChoice: todoController.tagList.value
                    .map((e) => S2Choice<int>(value: e.key!, title: e.value))
                    .toList(),
                choiceItems: todoController.tagOptions.value,
                onChange: (state) => todoController.setTags(state.choice),
              ),

              // Align(
              //   alignment: Alignment.centerRight,
              //   child: ElevatedButton(
              //     onPressed: () {
              //       Navigator.of(context).pop();
              //     },
              //     child: TextButton(
              //       child: const Text('Ekle'),
              //       onPressed: () {
              //         todoController.saveUserTodo();
              //       },
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
