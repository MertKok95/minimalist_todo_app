import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:todo_list_with_getx/constants/string_constants.dart';
import 'package:todo_list_with_getx/widgets/main/row_item.dart';
import '../constants/route_constants.dart';
import '../controller/todo_controller.dart';
import '../widgets/common/appbar.dart';

class MainScreen extends StatelessWidget {
  final todoController = Get.put(TodoController());

  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBarWidget(title: StringConstants.mainPageTitle, actions: [
        Obx(() => todoController.selectedItems.value.isNotEmpty
            ? getRemoveAction()
            : const SizedBox.shrink()),
      ]),
      floatingActionButton: _mainFloatingActionButton(),
      body: _mainBody(),
    );
  }

  Widget getRemoveAction() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: IconButton(
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
        onPressed: () {
          todoController.removeTodoItem();
          // onaylama popup eklenebilir
        },
      ),
    );
  }

  FloatingActionButton _mainFloatingActionButton() {
    return FloatingActionButton(
      onPressed: todoController.isEnableButton.value
          ? () {
              todoController.isEnableButton.value = false;
              todoController.allClear();
              Get.toNamed(RouteConstants.createTodoScreen);
              todoController.isEnableButton.value = true;
            }
          : () {},
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: Colors.black)),
      backgroundColor: Colors.white,
      child: const Icon(Icons.add),
    );
  }

  Container _mainBody() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: StreamBuilder(
        stream: todoController.getUserTodoList(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          List<QueryDocumentSnapshot<Map<String, dynamic>>> items =
              snapshot.data!.docs;
          todoController.setTodoList(items);

          return GroupedListView<dynamic, String>(
            elements: items,
            shrinkWrap: true,
            reverse: true,
            groupBy: (item) => (item['dueDate'] as String).substring(0, 10),
            groupSeparatorBuilder: (String groupByValue) => Text(groupByValue),
            itemComparator: (item1, item2) =>
                item1["priority"]["Key"].compareTo(item2["priority"]["Key"]),
            itemBuilder: (context, dynamic element) => Container(
              margin: const EdgeInsets.all(15),
              child: CustomRowItem(
                title: element["title"] ?? "",
                subtitle: (element["note"] as String).length > 20
                    ? (element["note"] as String).substring(0, 20)
                    : element["note"],
                date: element["dueDate"] ?? "",
                index: items.indexOf(
                    items.where((x) => x["key"] == element["key"]).first),
              ),
            ),
            floatingHeader: true,
            order: GroupedListOrder.DESC,
          );
        },
      ),
    );
  }
}
