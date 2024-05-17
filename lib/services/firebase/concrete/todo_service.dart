import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list_with_getx/services/firebase/abstract/abstract_todo_service.dart';

class TodoService extends ITodoService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

}
