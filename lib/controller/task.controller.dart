import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';

final taskControllerProvider = Provider<TaskController>((ref) {
  return TaskController(ref.read);
});

class TaskController {
  final Reader _reader;
  final tasksProvider = Provider<List<Task>>((ref) => []);
  TaskController(this._reader);

  Stream<List<Task>> getTasks() {
    return FirebaseFirestore.instance
        .collection('tasks')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Task(
          id: doc.id,
          title: data['title'],
          task: data['task'],
        );
      }).toList();
    });
  }

  Future<void> addTask(Task task) async {
    try {
      await FirebaseFirestore.instance.collection('tasks').add({
        'title': task.title,
        'task': task.task,
      });
    } catch (e) {
      print("Error adding task: $e");
    }
  }

  Future<void> updateTask(Task oldTask, Task newTask) async {
  try {
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(oldTask.id)
        .update({
          'title': newTask.title,
          'task': newTask.task,
        });

    // Notify listeners after updating a task
    _reader(tasksProvider).remove(oldTask);
    _reader(tasksProvider).add(newTask);
  } catch (e) {
    print("Error updating task: $e");
  }
}


  Future<void> deleteTask(Task task) async {
    try {
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(task.id)
          .delete();
               print("Deleting task with ID: ${task.id}");

      _reader(tasksProvider).remove(task);
    } catch (e) {
      print("Error deleting task: $e");
    }
  }
}
