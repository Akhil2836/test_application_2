import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_application_2/models/task.dart';

import '../controller/task.controller.dart';

final taskControllerProvider = Provider<TaskController>((ref) {
  return TaskController(ref.read);
});

class HomePage extends ConsumerWidget {
  List<Task> tasks = [];

  final titlecontroller = TextEditingController();

  final taskcontroller = TextEditingController();

  void _showEditDialog(BuildContext context, Task task, TaskController taskController) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titlecontroller..text = task.title,
                decoration: InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: taskcontroller..text = task.task,
                decoration: InputDecoration(labelText: "Task"),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                taskController.updateTask(task, Task(
                  id: UniqueKey().toString(),
                  title: titlecontroller.text,
                  task: taskcontroller.text,
                ));
                Navigator.pop(context); 
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, Task task, TaskController taskController) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Task"),
          content: Text("Are you sure you want to delete this task?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); 
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                taskController.deleteTask(task);
                print("df");
                Navigator.pop(context);
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskController = ref.watch(taskControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ToDo",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              elevation: 5,
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return Container(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    top: 20,
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextField(
                        controller: titlecontroller,
                        decoration: InputDecoration(
                          hintText: "Title",
                        ),
                      ),
                      TextField(
                        controller: taskcontroller,
                        decoration: InputDecoration(hintText: "Task"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          print("Button pressed");
                          final taskController =
                              ref.read(taskControllerProvider);
                          print("Controller obtained");
                          await taskController.addTask(Task(
                            id: UniqueKey().toString(),
                            title: titlecontroller.text,
                            task: taskcontroller.text,
                          ));
                          print("Task added");
                          titlecontroller.clear();
                          taskcontroller.clear();
                          Navigator.pop(context); // Close the bottom sheet
                          print("Navigation completed");
                        },
                        child: Text("Create Task"),
                      )
                    ],
                  ),
                );
              });
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<List<Task>>(
      stream: taskController.getTasks(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          tasks = snapshot.data!;
        }

        return tasks.isEmpty
            ? Center(child: Text("No Task"))
            : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (BuildContext, index) {
                  final mytask = tasks[index];
                  return Card(
                    child: ListTile(
                      title: Text(mytask.title),
                      subtitle: Text(mytask.task),
                      trailing: Wrap(
                        children: [
                          IconButton(
                            onPressed: () {
                              _showEditDialog(context, mytask, taskController);
                            },
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              _showDeleteDialog(context, mytask, taskController);
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
      },
    ),
    );
  }
}

