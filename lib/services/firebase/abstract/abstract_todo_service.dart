import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ITodoService {
  Future<QuerySnapshot<Map<String, dynamic>>> getPriorities();
  Future<QuerySnapshot<Map<String, dynamic>>> getCategories();
  Future<QuerySnapshot<Map<String, dynamic>>> getTags();
  Future<void> removeTodo(List<String> todoKeys);
}
