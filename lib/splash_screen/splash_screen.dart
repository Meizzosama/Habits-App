import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/todo_list/todo.dart';

class SplashScreenController extends GetxController {}

class SplashScreen extends StatelessWidget {
  final controller = Get.put(SplashScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.passthrough,
        children: [
          Column(
            children: [
              SizedBox(
                height: 480,
                width: 400,
                child: Image.asset(
                  'assets/profile.png',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 35.0),
                    child: Text(
                      "Are you ready",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Montserrat",
                      ),
                    ),
                  ),
                ],
              ),
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 35.0, top: 20),
                    child: Text(
                      "to build some habits?",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Montserrat",
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(30),
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => TodoList(),
                        transition: Transition.rightToLeft);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEBE983),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: const Text(
                      'Continue',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_forward,
                      size: 30,
                    ),
                    onPressed: () {
                      Get.to(() => TodoList(),
                          transition: Transition.rightToLeft);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
