import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:todo_list_with_getx/app/enums/message_enum.dart';
import '../app/enums/file_extension_enum.dart';
import '../app/helper/message_helper.dart';
import '../constants/string_constants.dart';
import '../controller/todo_controller.dart';
import '../widgets/main/bottom_sheet.dart';

class CreateTodoScreen extends StatelessWidget {
  const CreateTodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          StringConstants.todoPageTitle,
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark),
      ),
      body: TodoBody(),
    );
  }
}

class TodoBody extends StatelessWidget {
  final todoController = Get.find<TodoController>();

  TodoBody({super.key});

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
                          child: Text(
                              todoController.priorityList.value[index].value!),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              CustomElevatedButton(),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: TextButton(
                    child: const Text(StringConstants.mainAddTodo),
                    onPressed: () async {
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

class CustomElevatedButton extends StatelessWidget {
  final todoController = Get.find<TodoController>();

  CustomElevatedButton({super.key});

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
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return BottomSheetWidget();
              });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          child: Text(
            "Detay",
            style: TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
