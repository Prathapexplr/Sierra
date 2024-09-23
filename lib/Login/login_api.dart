import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

Future<bool> loginUserAPI(String userId, String password) async {
  var logger = Logger();

  final baseUrl = "https://dummyjson.com/auth/login";

  try {
    final response = await http.post(Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": userId,
          "password": password,
        }));

    if (response.statusCode == 200) {
      return true;
    } else {
      logger.d(response.body);
      return false;
    }
  } catch (e) {
    logger.d("Error $e");

    return false;
  }
}
