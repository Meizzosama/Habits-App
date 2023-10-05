import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TodoListController extends GetxController {
  final TextEditingController textEditingController = TextEditingController();
  final RxList<String> todoItems = <String>[].obs;
  final RxSet<String> doneTasks = <String>{}.obs;

  void addTodoItem(String task) {
    todoItems.add(task);
  }

  void markTaskAsDone(String task) {
    doneTasks.add(task);
    todoItems.remove(task);
  }

  void removeTodoItem(String task) {
    doneTasks.remove(task);
    todoItems.remove(task);
  }
}
