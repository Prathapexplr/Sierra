import 'package:flutter/material.dart';
import 'package:practicing/Check%20In/View/check_in_screen.dart';
import 'package:practicing/Check%20Out/check_out.dart';
import 'package:practicing/Login/LoginPage.dart';
import 'package:practicing/Room%20List/view/room_list_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CheckOutScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
