import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/todo_list/todolist_controller.dart';

class TodoList extends StatelessWidget {
  final TodoListController _controller = Get.put(TodoListController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              _showAddTaskDialog(context);
            },
            label: const Text(
              'Add New Habit',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: const Color(0xFF97C9D2),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Today.",
                  style: TextStyle(
                    fontSize: 32,
                    color: Color(0xFF302F29),
                    fontWeight: FontWeight.w500,
                    fontFamily: "Montserrat",
                  ),
                ),
              ),
              _buildTaskList(false),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Done",
                  style: TextStyle(
                    fontSize: 32,
                    color: Color(0xFF302F29),
                    fontWeight: FontWeight.w500,
                    fontFamily: "Montserrat",
                  ),
                ),
              ),
              _buildTaskList(true),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showAddTaskDialog(BuildContext context) async {
    TextEditingController taskController = TextEditingController();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: TextField(
            controller: taskController,
            decoration: const InputDecoration(
              hintText: 'Enter a task',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String task = taskController.text;
                if (task.isNotEmpty) {
                  _controller.addTodoItem(task);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTaskList(bool isDone) {
    return Obx(
      () => Column(
        children: [
          for (String task
              in isDone ? _controller.doneTasks : _controller.todoItems)
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.circular(30),
                ),
                height: 40,
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(task),
                    if (!isDone)
                      IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () {
                          _controller.markTaskAsDone(task);
                        },
                      ),
                    if (isDone)
                      IconButton(
                        icon: const Icon(Icons.cancel_outlined),
                        onPressed: () {
                          _controller.removeTodoItem(task);
                        },
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
