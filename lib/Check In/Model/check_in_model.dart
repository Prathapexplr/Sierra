// class RoomNoModel {
//   final String roomNo;

//   RoomNoModel({required this.roomNo});

//   factory RoomNoModel.fromJson(Map<String, dynamic> json) {
//     return RoomNoModel(
//       roomNo: json['roomNo'],
//     );
//   }
// }

class RoomNoModel {
  int? classCode;
  String? className;

  RoomNoModel({this.classCode, this.className});

  RoomNoModel.fromJson(Map<String, dynamic> json) {
    classCode = json['ClassCode'];
    className = json['ClassName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ClassCode'] = this.classCode;
    data['ClassName'] = this.className;
    return data;
  }
}


class RoomTypeModel {
  final List<String> roomTypes;

  RoomTypeModel({required this.roomTypes});

  factory RoomTypeModel.fromJson(List<dynamic> json) {
    return RoomTypeModel(
      roomTypes: json.map((type) => type['roomType'] as String).toList(),
    );
  }
}
