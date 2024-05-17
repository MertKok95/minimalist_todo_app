import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:todo_list_with_getx/app/enums/message_enum.dart';
import 'package:todo_list_with_getx/app/helper/notification_helper.dart';
import 'package:todo_list_with_getx/widgets/common/appbar.dart';
import '../app/enums/file_extension_enum.dart';
import '../app/helper/message_helper.dart';
import '../constants/string_constants.dart';
import '../controller/todo_controller.dart';
import '../widgets/main/detail_button.dart';

class CreateTodoScreen extends StatelessWidget {
  const CreateTodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBarWidget(title: StringConstants.todoPageTitle),
      body: TodoBody(),
    );
  }
}

class TodoBody extends StatelessWidget {
  final todoController = Get.find<TodoController>();

  TodoBody({super.key});

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
        child: _todoList(context),
      ),
    );
  }

  SingleChildScrollView _todoList(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(StringConstants.mainLabelTitle,
              style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          TextField(
            onChanged: (value) {
              todoController.title.value = value;
            },
            decoration: InputDecoration(
              hintText: StringConstants.mainInputTitleHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(StringConstants.mainLabelNoteHint,
              style: TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          TextField(
            onChanged: (value) {
              todoController.note.value = value;
            },
            maxLines: 3,
            decoration: InputDecoration(
              hintText: StringConstants.mainInputNoteHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(StringConstants.mainLabelPriority,
              style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Container(
            // width: MediaQuery.of(context).size.width * 0.8,
            margin: const EdgeInsets.only(bottom: 10),
            child: Obx(
              () => Wrap(
                direction: Axis.horizontal,
                children: List.generate(
                    todoController.priorityList.value.length, (int index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            todoController.priorityColor.value[index],
                      ),
                      onPressed: () => todoController.setPriorty(index),
                      child:
                          Text(todoController.priorityList.value[index].value!),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 10),
          DetailButton(),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: TextButton(
                child: const Text(StringConstants.mainAddTodo),
                onPressed: () async => todoController.isEnableTodo.value
                    ? saveTodo(context)
                    : () {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  pickFiles() async {
    var result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: [
          FileExtensions.pdf.toString(),
          FileExtensions.xls.toString(),
          FileExtensions.xlsx.toString(),
          FileExtensions.doc.toString(),
          FileExtensions.docx.toString()
        ]);
    if (result != null) {
      todoController.addAttachmentToTask(result.files);
    }
  }

  Future saveTodo(context) async {
    var errorMessage = await todoController.saveUserTodo();
    if (errorMessage.isNotEmpty) {
      var messageInstance = MessageHelper(
          mainCointext: context,
          messageTypes: MessageTypes.error,
          messageStyles: MessageStyles.minimal,
          title: 'Hata',
          message: errorMessage);

      messageInstance.ShowMessage();
    }
  }
}
