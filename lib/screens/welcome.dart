import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:note_with_tflite/const.dart';
import 'package:note_with_tflite/screens/sign_up.dart';

class LoginController extends GetxController {
  // var _isLoggedIn = true.obs;
  //
  // var box = Hive.box("login_state");
  //
  // LoginController() {
  //   _isLoggedIn.value = box.get("is_loged_in", defaultValue: false);
  // }
  //
  // void changeState(bool isLoggedIn) {
  //   box.put("is_logged_in", isLoggedIn);
  // }
  //
  // void getLoginState() => _isLoggedIn.value = !_isLoggedIn.value;
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Placeholder(
        child: Container(
            color: Constants.backgroundColor,
            child: Center(
              child: IntrinsicWidth(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.buttonColor),
                      child: const Text("Login"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.buttonColor),
                      child: const Text("Sign up"),
                    ),
                  ],
                ),
              ),
            )));
  }
}
