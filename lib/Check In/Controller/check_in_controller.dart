import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:practicing/Check%20In/Model/check_in_model.dart';
import 'package:http/http.dart' as http;

class CheckInController {
  var logger = Logger();

  // final String vacantRoomNoUrl = "http://wsdb01/APITesting/api/Users/getroomnovacant";

  final String vacantRoomNoUrl = "https://gssskhokhar.com/api/classes/";

  String vacantRoomTypeUrl = "http://wsdb01/APITesting/api/Users/getroomnotype";

  Future<List<RoomNoModel>> fetchRoomNo() async {
    final response = await http.get(Uri.parse(vacantRoomNoUrl));

    if (response.statusCode == 200) {
      logger.d("Fetched Room Successfully");

      List<dynamic> data = json.decode(response.body);

      return data
          .map((dynamic roomNo) => RoomNoModel.fromJson(roomNo))
          .toList();
    } else {
      throw Exception("Failer fetching Noom No");
    }
  }

  Future<RoomTypeModel> fetchRoomType(String roomNo) async {
  final roomNoFetchedUrl = "$vacantRoomNoUrl?id=$roomNo";
  final response = await http.get(Uri.parse(roomNoFetchedUrl));

  logger.d("Room Type API Url : $roomNoFetchedUrl");

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return RoomTypeModel.fromJson(data);
  } else {
    throw Exception("Failed to Load Room Type");
  }
}

}
