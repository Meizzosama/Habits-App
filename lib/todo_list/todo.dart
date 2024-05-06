// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/todo_list/todolist_controller.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final TodoListController _controller = Get.put(TodoListController());
  static const String todoKey = 'todo_list_key';
  double fabHeight = 56.0;
  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('MMMM d, yyyy').format(DateTime.now());
    List<Widget> dayColumns = [];

    for (int i = 0; i < 7; i++) {
      DateTime day = DateTime.now().subtract(Duration(days: -i));
      String formattedDate = DateFormat('d').format(day);
      String formattedDay = DateFormat('E').format(day);

      final isCurrentDate = i == 0;

      dayColumns.add(
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    isCurrentDate
                        ? const Color(0xFFFFF176)
                        : const Color(0xFFFF8A65),
                    isCurrentDate
                        ? const Color(0xFFFFD54F)
                        : const Color(0xFFFF7043),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              height: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    formattedDay,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return WillPopScope(
      onWillPop: () async {
        await _saveData();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFF9FAFD),
          resizeToAvoidBottomInset: false,
          floatingActionButton: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: fabHeight,
            child: FloatingActionButton.extended(
              onPressed: () {
                _showAddTaskDialog(context);
              },
              label: const Text(
                'Add New Habit',
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: const Color(0xFF97C9D2),
            ),
          ),
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 25.0),
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
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, bottom: 14.0),
                  child: Text(
                    currentDate,
                    style: const TextStyle(
                      fontSize: 22,
                      color: Color(0xFF302F29),
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                      fontFamily: "Montserrat",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    ...dayColumns,
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "To Do",
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                _buildTaskList(false),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  color: Colors.black,
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Done",
                    style: TextStyle(
                        fontSize: 32,
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                _buildTaskList(true),
                const SizedBox(
                  height: 65,
                ),
              ],
            ),
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
          title: const Text('Add New Habit'),
          content: TextField(
            controller: taskController,
            decoration: const InputDecoration(
                hintText: 'Enter a Habit',
                hintStyle: TextStyle(color: Colors.black)),
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
                  _saveData();
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

  Future<void> _showEditTaskDialog(
      BuildContext context, String taskToEdit) async {
    TextEditingController taskController =
        TextEditingController(text: taskToEdit);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: TextField(
            controller: taskController,
            decoration: const InputDecoration(
                hintText: 'Edit the task',
                hintStyle: TextStyle(color: Colors.black)),
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
                String updatedTask = taskController.text;
                if (updatedTask.isNotEmpty) {
                  _controller.editTodoItem(taskToEdit, updatedTask);
                  _saveData();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Edit'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTaskList(bool isDone) {
    return Obx(
      () {
        final List<String> tasks = isDone
            ? _controller.doneTasks.toList()
            : _controller.todoItems.toList();

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            final words = task.split(' ');
            final displayText = words.take(10).join(' ');

            return Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 20),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        isDone
                            ? const Color(0xFFFFF176)
                            : const Color(0xFFFF8A65),
                        isDone
                            ? const Color(0xFFFFD54F)
                            : const Color(0xFFFF7043),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  height: 45,
                  width: 340,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          displayText, // Display the limited text
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      if (!isDone)
                        IconButton(
                          icon: const Icon(Icons.check_box_outlined),
                          onPressed: () {
                            _controller.markTaskAsDone(task);
                          },
                        ),
                      if (!isDone)
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showEditTaskDialog(context, task);
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
            );
          },
        );
      },
    );
  }

  Future<void> _loadData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? todoItems = prefs.getStringList(todoKey);

      if (todoItems != null) {
        _controller.setTodoItems(todoItems);
      }
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  Future<void> _saveData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(todoKey, _controller.todoItems.toList());
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }
}
