// // models/room.dart

// class RoomModel {
//   final int roomNo;
//   final String roomType;
//   final String status;
//   final String? occupiedBy;
//   final String? vacatingDate;

//   RoomModel({
//     required this.roomNo,
//     required this.roomType,
//     required this.status,
//     this.occupiedBy,
//     this.vacatingDate,
//   });

//   factory RoomModel.fromJson(Map<String, dynamic> json) {
//     return RoomModel(
//       roomNo: json['rm_no'],
//       roomType: json['rm_type'],
//       status: json['status'],
//       occupiedBy: json['occupied_by'],
//       vacatingDate: json['cin_coutdt'],
//     );
//   }
// }

class RoomModel {
  int? orderID;
  String? customerID;
  int? employeeID;
  double? freight;
  String? shipCity;
  bool? verified;
  String? orderDate;
  String? shipName;
  String? shipCountry;
  String? shippedDate;
  String? shipAddress;

  RoomModel(
      {this.orderID,
      this.customerID,
      this.employeeID,
      this.freight,
      this.shipCity,
      this.verified,
      this.orderDate,
      this.shipName,
      this.shipCountry,
      this.shippedDate,
      this.shipAddress});

  RoomModel.fromJson(Map<String, dynamic> json) {
    orderID = json['OrderID'];
    customerID = json['CustomerID'];
    employeeID = json['EmployeeID'];
    freight = json['Freight'];
    shipCity = json['ShipCity'];
    verified = json['Verified'];
    orderDate = json['OrderDate'];
    shipName = json['ShipName'];
    shipCountry = json['ShipCountry'];
    shippedDate = json['ShippedDate'];
    shipAddress = json['ShipAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OrderID'] = orderID;
    data['CustomerID'] = customerID;
    data['EmployeeID'] = employeeID;
    data['Freight'] = freight;
    data['ShipCity'] = shipCity;
    data['Verified'] = verified;
    data['OrderDate'] = orderDate;
    data['ShipName'] = shipName;
    data['ShipCountry'] = shipCountry;
    data['ShippedDate'] = shippedDate;
    data['ShipAddress'] = shipAddress;
    return data;
  }
}
