// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:practicing/Login/login_api.dart';
import 'package:practicing/Room%20List/view/room_list_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void loginFunction() async {
    if (_formKey.currentState!.validate()) {
      String userName = userIdController.text;
      String passWord = passwordController.text;

      bool isValidUser = await loginUserAPI(userName, passWord);

      if (isValidUser) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Successfully Logged In")));
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return const RoomListScreen();
          },
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid UserName or Password")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Container(
            width: MediaQuery.sizeOf(context).width / 1.7,
            height: MediaQuery.sizeOf(context).height / 1.7,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black)),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text('LOGIN SCREEN'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("User ID"),
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        controller: userIdController,
                        // keyboardType: TextInputType.number,
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.digitsOnly
                        // ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Fill out the User Id Field";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Password"),
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        controller: passwordController,
                        // keyboardType: TextInputType.number,
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.digitsOnly
                        // ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter Password";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          loginFunction();
                        },
                        child: const Text("Submit"))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
