import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:todo_app/splash_screen/splash_screen.dart';

void main() => runApp(const TodoApp());

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo List App',
      theme: ThemeData(
        fontFamily: "Montserrat",
        primaryColor: Colors.blue,
        hintColor: Colors.green,
      ),
      home: SplashScreen(),
    );
  }
}
