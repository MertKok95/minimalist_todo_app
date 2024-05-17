import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_select/flutter_awesome_select.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:todo_list_with_getx/app/helper/helper_methods.dart';
import 'package:todo_list_with_getx/model/tag_model.dart';
import 'package:todo_list_with_getx/services/firebase/abstract/abstract_todo_service.dart';

import '../app/cache/cache_manager.dart';
import '../app/helper/notification_helper.dart';
import '../app/locator/get_it_locator.dart';
import '../model/category_model.dart';
import '../model/priority_model.dart';
import '../model/todo_model.dart';
import '../model/user_model.dart';

class TodoController extends GetxController {
  Rx<List<File>> pickedFiles = Rx<List<File>>([]);
  Rx<List<TodoModel>> todoList = Rx<List<TodoModel>>([]);
  Rx<List<String>> selectedItems = Rx<List<String>>([]);
  Rx<List<PriorityModel>> priorityList = Rx<List<PriorityModel>>([]);
  Rx<List<CategoryModel>> categoryList = Rx<List<CategoryModel>>([]);
  var hasAttachment = false.obs;
  var isConfirmed = false.obs;
  Rx<String?> title = "".obs;
  Rx<String?> note = "".obs;
  Rx<String> date = "".obs;
  Rx<CategoryModel?> category = Rx(CategoryModel());
  Rx<PriorityModel?> priority = Rx(PriorityModel());
  Rx<List<Color>> priorityColor = Rx<List<Color>>([]);
  Rx<List<TagModel>> tagList = Rx<List<TagModel>>([]);
  Rx<List<S2Choice<int>>> tagOptions = Rx<List<S2Choice<int>>>([]);

  Rx<bool> isEnableButton = true.obs;

  List<String> errorMessages = [];

  var defaultPriorityColor = const Color.fromARGB(255, 250, 245, 251);
  var selectedPriorityColor = const Color.fromARGB(255, 176, 233, 246);

  final ITodoService _todoService = locator<ITodoService>();

  TodoController() {
    getUserTodoList();
    loadInitialData();
  }

  loadInitialData() async {
    var priorityCollection = await _todoService.getPriorities();
    var categoryCollection = await _todoService.getCategories();
    var tagCollection = await _todoService.getTags();

    for (var element in priorityCollection.docs) {
      priorityList.value.add(PriorityModel().fromJson(element.data()));
      priorityColor.value.add(defaultPriorityColor);
    }

    categoryList.value.add(CategoryModel(key: 0, value: "Seç"));
    for (var element in categoryCollection.docs) {
      categoryList.value.add(CategoryModel().fromJson(element.data()));
    }

    for (var element in tagCollection.docs) {
      var data = element.data();
      tagOptions.value
          .add(S2Choice<int>(value: data["Key"], title: data["Value"]));
    }
  }

  allClear() {
    isEnableButton.value = true;
    title.value = "";
    note.value = "";
    priority.value = null;
    cancelTodoDetails();
    priorityColor.value =
        priorityColor.value.map((p) => defaultPriorityColor).toList();
    priorityColor.refresh();
  }

  cancelTodoDetails() {
    category.value = null;
    date.value = "";
    tagList.value.clear();
    pickedFiles.value.clear();
    pickedFiles.refresh();
    tagList.refresh();
  }

  setPriorty(int index) {
    var i = 0;
    for (var element in priorityList.value) {
      if (element.key == index + 1) {
        priority.value = priorityList.value[index];
        priorityColor.value[index] = selectedPriorityColor;
      } else {
        priorityColor.value[i] = defaultPriorityColor;
      }
      i++;
    }
    priorityColor.refresh();
  }

  setCategory(String name) {
    var i = 0;

    for (var element in categoryList.value) {
      if (element.value == name) {
        category.value = categoryList.value[i];
      }
      i++;
    }
  }

  setTags(List<S2Choice<int>>? tags) {
    if (tags != null) {
      tagList.value.clear();
      for (var element in tags) {
        tagList.value.add(TagModel(key: element.value, value: element.title));
      }
      tagList.refresh();
    }
  }

  selectTodoItem(itemKey, value) {
    if (selectedItems.value.any((key) => key == itemKey)) {
      selectedItems.value.remove(itemKey);
    } else {
      selectedItems.value.add(itemKey);
    }
    selectedItems.refresh();
  }

  removeTodoItem() async {
    await _todoService.removeTodo(selectedItems.value);
    selectedItems.value.clear();
    selectedItems.refresh();
  }

  addAttachmentToTask(List<PlatformFile> files) {
    pickedFiles.value.clear();
    for (var item in files.map((file) => File(file.path!)).toList()) {
      pickedFiles.value.add(item);
    }
    hasAttachment.value = true;
    pickedFiles.refresh();
  }

  Future<String> saveUserTodo() async {
    isEnableButton.value = false;
    var user =
        CacheManager.getInstance.getCacheItem<UserModel>("UserId", UserModel());
    errorMessages.clear();
    if (user == null) {
      errorMessages.add("Kullanıcı bilgisi bulunamadı");
    }

    isEmptyOrNull();

    if (errorMessages.isEmpty) {
      var todoModel = TodoModel(
          uid: user!.uid,
          key: HelperMethods().getRandomString(15),
          title: title.value,
          note: note.value,
          priority: priority.value,
          category: category.value != null
              ? CategoryModel(
                  key: category.value!.key!, value: category.value!.value!)
              : CategoryModel(),
          tags: tagList.value,
          dueDate: date.value);

      List<String> attachmentNames = [];

      if (pickedFiles.value.isNotEmpty) {
        for (var file in pickedFiles.value!) {
          String fName = basename((file).path);
          var fileName = "${todoModel.key}-$fName";
          attachmentNames.add(fileName);
          await saveUserFilesToStorage(user.uid!, fileName, file);
        }
      }
      todoModel.attachments = attachmentNames;
      await FirebaseFirestore.instance
          .collection("UserTodo")
          .doc(todoModel.key)
          .set(todoModel.toJson());

      addLocalNotification();
      todoList.refresh();
    }

    String response = "";

    for (var message in errorMessages) {
      response += message + "\n";
    }
    isEnableButton.value = true;
    return response;
  }

  addLocalNotification() {
    var differences = DateTime.parse(date.value).difference(DateTime.now());
    int diffDay = differences.inDays;
    int dayMinute = differences.inMinutes.remainder(60);

    if (diffDay > 1 || (diffDay == 1 && dayMinute > 5)) {
      NotificationHelper.showScheduleNotification(
          id: todoList.value.length + 1,
          title: title.value!,
          body: note.value!,
          payload: note.value!,
          dateTime: DateTime.parse(date.value));
    }
  }

  setTodoList(List<QueryDocumentSnapshot<Map<String, dynamic>>> data) {
    for (var element in data) {
      todoList.value.add(TodoModel().fromJson(element.data()));
    }
    todoList.refresh();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserTodoList() {
    var user =
        CacheManager.getInstance.getCacheItem<UserModel>("UserId", UserModel());
    if (user != null) {
      return FirebaseFirestore.instance
          .collection("UserTodo")
          .where("uid", isEqualTo: user.uid)
          .snapshots();
    }
    return const Stream.empty();
  }

  saveUserFilesToStorage(
      String userCurrentId, String fileName, File file) async {
    Reference reference = FirebaseStorage.instance
        .ref()
        .child("UserTodoFiles")
        .child(userCurrentId)
        .child(fileName);
    await reference.putFile(file);
  }

  isEmptyOrNull() {
    if (title.value == null || title.value == "") {
      errorMessages.add("Başlık giriniz");
    }
    if (note.value == null || note.value == "") {
      errorMessages.add("İçerik ekleyiniz");
    }

    if (date.value == "") {
      date.value = DateTime.now().toIso8601String();
    }

    if (priority.value == null) {
      errorMessages.add("Öncelik belirlenmeli");
    } else if (priority.value != null &&
        (priority.value!.value == null || priority.value!.value == "")) {
      errorMessages.add("Öncelik belirlenmeli");
    }
  }

  getDate(date) {
    return HelperMethods().getCustomDate(date);
  }
}
