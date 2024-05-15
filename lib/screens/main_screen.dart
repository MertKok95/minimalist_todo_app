import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:todo_list_with_getx/constants/string_constants.dart';
import 'package:todo_list_with_getx/widgets/main/row_item.dart';
import '../constants/route_constants.dart';
import '../controller/todo_controller.dart';

class MainScreen extends StatelessWidget {
  final todoController = Get.put(TodoController());

  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _appBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          todoController.allClear();
          Get.toNamed(RouteConstants.createTodoScreen);
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: const BorderSide(color: Colors.black)),
        backgroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder(
          stream: todoController.getUserTodoList(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            List<QueryDocumentSnapshot<Map<String, dynamic>>> items =
                snapshot.data!.docs;
            todoController.setTodoList(items);

            items.sort((a, b) {
              return b["priority"]["Key"].compareTo(a["priority"]["Key"]);
            });

            return GroupedListView<dynamic, String>(
              elements: items,
              reverse: true,
              groupBy: (item) => (item['dueDate'] as String).substring(0, 10),
              groupSeparatorBuilder: (String groupByValue) =>
                  Text(groupByValue),
              itemBuilder: (context, dynamic element) => Container(
                margin: const EdgeInsets.all(15),
                child: CustomRowItem(
                  title: element["title"] ?? "",
                  subtitle: element["category"]["Value"] ?? "",
                  date: element["dueDate"] ?? "",
                  index: 0,
                ),
              ),
              floatingHeader: true,
              order: GroupedListOrder.DESC,
            );
          },
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      title: const Text(
        StringConstants.mainPageTitle,
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      foregroundColor: Colors.black,
      backgroundColor: Colors.white,
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark),
    );
  }
}
