import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../abstract/abstract_todo_service.dart';

class TodoService extends ITodoService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> getCategories() async {
    return await firestore.collection("Category").get();
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> getPriorities() async {
    return await firestore.collection("Priority").get();
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> getTags() async {
    return await firestore.collection("Tags").get();
  }

  Future<void> removeTodo(List<String> todoKeys) async {
    for (var key in todoKeys) {
      QuerySnapshot<Map<String, dynamic>> collection = await firestore
          .collection('UserTodo')
          .where("key", isEqualTo: key)
          .get();
      for (var document in collection.docs) {
        // dökümana bağla belgelerin silinmesi
        List<String> attachments = (document.get("attachments") as List)
            .map((e) => e.toString())
            .toList();
        if (attachments.isNotEmpty) {
          for (var attachment in attachments) {
            await storage
                .ref()
                .child("UserTodoFiles")
                .child(document.get("uid"))
                .child(attachment)
                .delete();
          }
        }
        // kullanıcı todo silinmesi
        await firestore.collection("UserTodo").doc(document.id).delete();
        // then metodu eklenerek hata kontrollü yapılabilir
      }
    }
  }
}
