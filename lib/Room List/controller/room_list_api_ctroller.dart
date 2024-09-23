import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:practicing/Room%20List/model/room_list_model.dart';
import 'package:http/http.dart' as http;

class RoomListApiCtroller {
  var logger = Logger();

  final String roomListApiUrl =
      "https://ej2services.syncfusion.com/production/web-services/api/Orders";

  Future<List<RoomModel>> fetchRoomList() async {
    final response = await http.get(Uri.parse(roomListApiUrl));

    if (response.statusCode == 200) {
      logger.d("Room Fetched Successfully");

      List<dynamic> data = json.decode(response.body);

      // logger.d(response.body);

      return data.map((room) => RoomModel.fromJson(room)).toList();
    } else {
      throw Exception("Failer");
    }
  }
}
