import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:todo_list_with_getx/constants/string_constants.dart';
import 'package:todo_list_with_getx/model/todo_model.dart';
import 'package:todo_list_with_getx/widgets/main/row_item.dart';

import '../controller/todo_controller.dart';
import '../widgets/main/bottom_sheet.dart';

class MainScreen extends StatelessWidget {
  final todoController = Get.put(TodoController());

  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark),
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return BottomSheetWidget();
              });
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: const BorderSide(color: Colors.black)),
        backgroundColor: Colors.white,
        child: const Icon(Icons.add), //<-- SEE HERE
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const Text(
                StringConstants.mainTodoList,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                  height: 500,
                  child: StreamBuilder(
                    stream: todoController.getUserTodoList(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<QueryDocumentSnapshot<Map<String, dynamic>>>
                            items = snapshot.data!.docs;
                        todoController.setTodoList(items);
                        return ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return CustomRowItem(
                              title: items[index]["title"] ?? "",
                              subtitle: items[index]["category"]["Value"] ?? "",
                              date: items[index]["dueDate"] ?? "",
                              index: index,
                            );
                          },
                        );
                      }
                      return Container();
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
