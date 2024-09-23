import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:practicing/Check%20In/Controller/check_in_controller.dart';
import 'package:practicing/Check%20In/Model/check_in_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  var logger = Logger();

  List<RoomNoModel> roomNoData = [];
  String? selectedRoomNo;
  String? roomTypeSaving;
  bool isLoadingRoomNo = true;

  // Controllers for the input fields
  final TextEditingController guestNameController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController rentController = TextEditingController();
  final TextEditingController advanceController = TextEditingController();

  DateTime? checkInDate;
  DateTime? checkOutDate;

  @override
  void initState() {
    super.initState();
    roomNoFunc();
  }

  void roomNoFunc() async {
    try {
      roomNoData = await CheckInController().fetchRoomNo();
      setState(() {
        isLoadingRoomNo = false;
      });
    } catch (e) {
      logger.d("Failed to Load Data $e");
      setState(() {
        isLoadingRoomNo = false;
      });
    }
  }

  void roomTypeFunction(String roomNo) async {
    try {
      var checkInController = CheckInController();
      RoomTypeModel roomTypeModel = await checkInController.fetchRoomType(roomNo);
      setState(() {
        roomTypeSaving = roomTypeModel.roomTypes.toString();
      });
    } catch (e) {
      logger.d(e);
    }
  }

  Future<void> saveData() async {
    final response = await http.post(
      Uri.parse('http://wsdb01/APITesting/api/Users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "cin_bookingdt": checkInDate?.toIso8601String(),
        "cin_cindt": checkInDate?.toIso8601String(),
        "cin_coutdt": checkOutDate?.toIso8601String(),
        "cin_rm_no": selectedRoomNo,
        "cin_rent": double.tryParse(rentController.text) ?? 0,
        "cin_deposit": double.tryParse(advanceController.text) ?? 0,
        "cin_phoneno": phoneNoController.text,
        "cin_name": guestNameController.text,
        "cin_address": addressController.text,
        "cin_purpose": purposeController.text,
      }),
    );

    if (response.statusCode == 200) {
      logger.d("Data saved successfully!");
      // Handle success (e.g., show a success message, navigate back, etc.)
    } else {
      logger.d("Failed to save data. Status code: ${response.statusCode}");
      // Handle error (e.g., show an error message)
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isWideScreen = MediaQuery.of(context).size.width > 500;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Check In Data"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: isWideScreen
            ? const Column(
                children: [Text("Laptop")],
              )
            : Column(
                children: [
                  Row(
                    children: [
                      const Text("Room NO"),
                      const SizedBox(width: 20),
                      DropdownButton(
                        value: selectedRoomNo,
                        items: roomNoData.map((RoomNoModel roomNo) {
                          return DropdownMenuItem(
                            value: roomNo.className,
                            child: Text(roomNo.className.toString()),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedRoomNo = newValue;
                            roomTypeFunction(newValue!);
                            logger.d("Room NO : $newValue");
                          });
                        },
                        hint: const Text("Select Room No"),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("Room Type"),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: "Room Type"),
                          controller: TextEditingController(text: roomTypeSaving),
                          readOnly: true,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: guestNameController,
                          decoration: const InputDecoration(labelText: "Guest Name"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: phoneNoController,
                          decoration: const InputDecoration(labelText: "Phone No"),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(labelText: "Check-in Date"),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: checkInDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                checkInDate = pickedDate;
                              });
                            }
                          },
                          controller: TextEditingController(text: checkInDate?.toLocal().toString().split(' ')[0]),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(labelText: "Check-out Date"),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: checkOutDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                checkOutDate = pickedDate;
                              });
                            }
                          },
                          controller: TextEditingController(text: checkOutDate?.toLocal().toString().split(' ')[0]),
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(labelText: "Address"),
                  ),
                  TextFormField(
                    controller: purposeController,
                    decoration: const InputDecoration(labelText: "Purpose of Visit"),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: rentController,
                          decoration: const InputDecoration(labelText: "Rent"),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: advanceController,
                          decoration: const InputDecoration(labelText: "Advance"),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: saveData,
                        child: const Text("Save"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle cancel action (e.g., clear fields, navigate back, etc.)
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
