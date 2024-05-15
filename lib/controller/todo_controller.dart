import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_select/flutter_awesome_select.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:todo_list_with_getx/constants/string_constants.dart';
import 'package:todo_list_with_getx/model/tag_model.dart';

import '../app/cache/cache_manager.dart';
import '../model/category_model.dart';
import '../model/priority_model.dart';
import '../model/todo_model.dart';
import '../model/user_model.dart';

class TodoController extends GetxController {
  Rx<List<File>> pickedFiles = Rx<List<File>>([]);
  Rx<List<TodoModel>> todoList = Rx<List<TodoModel>>([]);
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

  List<String> errorMessages = [];

  var defaultPriorityColor = const Color.fromARGB(255, 250, 245, 251);
  var selectedPriorityColor = const Color.fromARGB(255, 176, 233, 246);

  TodoController() {
    getUserTodoList();
    loadPriorityList();
    loadCategoryList();
    loadTags();
  }

  loadPriorityList() async {
    var collection =
        await FirebaseFirestore.instance.collection("Priority").get();
    for (var element in collection.docs) {
      priorityList.value.add(PriorityModel().fromJson(element.data()));
      priorityColor.value.add(defaultPriorityColor);
    }
  }

  loadCategoryList() async {
    var collection =
        await FirebaseFirestore.instance.collection("Category").get();
    categoryList.value.add(CategoryModel(key: 0, value: "Seç"));
    for (var element in collection.docs) {
      categoryList.value.add(CategoryModel().fromJson(element.data()));
    }
    // category.value = categoryList.value[0]; if you want as default value
  }

  loadTags() async {
    var collection = await FirebaseFirestore.instance.collection("Tags").get();
    for (var element in collection.docs) {
      var data = element.data();
      tagOptions.value
          .add(S2Choice<int>(value: data["Key"], title: data["Value"]));
    }
  }

  allClear() {
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

  selectTodoItem(index, value) {
    todoList.value[index].isCompleted = value;
    todoList.refresh();
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
          key: getRandomString(15),
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
          var fileName = "${user.uid}-$fName";
          attachmentNames.add(fileName);
          await saveUserFilesToStorage(user.uid!, fileName, file);
        }
      }
      todoModel.attachments = attachmentNames;
      await FirebaseFirestore.instance
          .collection("UserTodo")
          .doc(todoModel.key)
          .set(todoModel.toJson());
    }

    String response = "";

    for (var message in errorMessages) {
      response += message + "\n";
    }
    return response;
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

  String getRandomString(int length) {
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => StringConstants.chars
            .codeUnitAt(Random().nextInt(StringConstants.chars.length)),
      ),
    );
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
}
