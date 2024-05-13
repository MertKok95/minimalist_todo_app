import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_select/flutter_awesome_select.dart';
import 'package:get/get.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';
import 'package:todo_list_with_getx/controller/todo_controller.dart';
import 'package:todo_list_with_getx/widgets/common/file_attachment.dart';

class BottomSheetWidget extends StatelessWidget {
  final todoController = Get.find<TodoController>();

  BottomSheetWidget({super.key});

  pickFiles() async {
    var result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'xls', 'xlsx', 'doc', 'docx']);
    if (result != null) {
      todoController.addAttachmentToTask(result.files);
    }
  }

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
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  FileAttachmentWidget(
                    onAttachmentPressed: pickFiles,
                  )
                ],
              ),
              const SizedBox(height: 16),
              const Text('Görev Ekle', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              TextField(
                onChanged: (value) {
                  todoController.title.value = value;
                },
                decoration: InputDecoration(
                  hintText: 'Başlık',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text('Priority', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Container(
                // width: MediaQuery.of(context).size.width * 0.8,
                margin: EdgeInsets.only(bottom: 10),
                child: Obx(
                  () => Wrap(
                    direction: Axis.horizontal,
                    children: List.generate(
                        todoController.priorityList.value.length, (int index) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              todoController.priorityColor.value[index],
                        ),
                        onPressed: () => todoController.setPriorty(index),
                        child: Text(
                            todoController.priorityList.value[index].value!),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  todoController.note.value = value;
                },
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Görev İçeriği',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text('Category', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              CustomDropdown<String>(
                hintText: 'Select Category',
                items: todoController.categoryList.value
                    .map((data) => data.value!)
                    .toList(),
                initialItem: todoController.categoryList.value[0].value,
                decoration:
                    CustomDropdownDecoration(closedFillColor: Colors.grey[200]),
                onChanged: (value) => todoController.setCategory(value),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Bitiş Tarihi Seç',
                      style: TextStyle(fontSize: 18)),
                  TimePickerSpinnerPopUp(
                    mode: CupertinoDatePickerMode.date,
                    initTime: DateTime.now(),
                    minTime: DateTime.now().subtract(const Duration(days: 10)),
                    maxTime: DateTime.now().add(const Duration(days: 180)),
                    barrierColor:
                        Colors.black12, //Barrier Color when pop up show
                    minuteInterval: 1,
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    cancelText: 'Cancel',
                    confirmText: 'OK',
                    pressType: PressType.singlePress,
                    timeFormat: 'dd/MM/yyyy',
                    onChange: (dateTime) {
                      todoController.date.value = dateTime.toIso8601String();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SmartSelect<int>.multiple(
                title: 'Tags',
                selectedChoice: todoController.tagList.value
                    .map((e) => S2Choice<int>(value: e.key!, title: e.value))
                    .toList(),
                choiceItems: todoController.tagOptions.value,
                onChange: (state) => todoController.setTags(state.choice),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: TextButton(
                    child: const Text('Ekle'),
                    onPressed: () {
                      todoController.saveUserTodo();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
