import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:todo/model/task.dart';
import 'package:todo/sharedpref.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  String currentUserid = '';
  final String collectionUser = 'users';
  final String collectionTasks = 'tasks';

  List<Task> get tasks {
    return [..._tasks];
  }

  Future<void> getTasks() async {
    currentUserid = SharedPrefUtil.getInstance().getData('userid');
    try {
      _tasks.clear();
      QuerySnapshot res = await Firestore.instance
          .collection(collectionUser)
          .document(currentUserid)
          .collection(collectionTasks)
          .getDocuments();

      if (res.documents.length != _tasks.length) {
        res.documents.forEach((element) {
          Timestamp lastEdit = element.data['lastEdit'];
          Task task = Task(
              id: element.documentID,
              title: element.data['title'],
              lastEdit: lastEdit.toDate(),
              description: element.data['description'],
              isDone: element.data['isDone']);
          _tasks.add(task);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> addTask(String title, String desc) async {
    currentUserid = SharedPrefUtil.getInstance().getData('userid');

    try {
      if (title.isNotEmpty && desc.isNotEmpty) {
        Task task = Task(
          title: title,
          description: desc,
          isDone: false,
          lastEdit: DateTime.now(),
        );
        _tasks.add(task);
        await Firestore.instance
            .collection(collectionUser)
            .document(currentUserid)
            .collection(collectionTasks)
            .document()
            .setData({
          'title': task.title,
          'description': task.description,
          'isDone': false,
          'lastEdit': DateTime.now(),
        });

        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> editTask(String title, String desc, Task t) async {
    currentUserid = SharedPrefUtil.getInstance().getData('userid');

    _tasks.remove(t);
    try {
      await Firestore.instance
          .collection(collectionUser)
          .document(currentUserid)
          .collection(collectionTasks)
          .document(t.id)
          .setData(
        {
          'title': title.isEmpty ? t.title : title,
          'description': desc.isEmpty ? t.description : desc,
          'isDone': t.isDone,
          'lastEdit': DateTime.now(),
        },
        merge: true,
      );
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    currentUserid = SharedPrefUtil.getInstance().getData('userid');

    try {
      await Firestore.instance
          .collection(collectionUser)
          .document(currentUserid)
          .collection(collectionTasks)
          .document(id)
          .delete();
    } catch (e) {
      print(e);
    }
    _tasks.removeWhere((element) => element.id == id);
  }

  Future<void> toogleIsDone(Task t) async {
    currentUserid = SharedPrefUtil.getInstance().getData('userid');

    try {
      await Firestore.instance
          .collection(collectionUser)
          .document(currentUserid)
          .collection(collectionTasks)
          .document(t.id)
          .setData({
        'title': t.title,
        'description': t.description,
        'isDone': !t.isDone,
        'lastEdit': DateTime.now(),
      }, merge: true);
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
}
