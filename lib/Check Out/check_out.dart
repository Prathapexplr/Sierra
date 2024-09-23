import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckOutScreen> {
  var logger = Logger();
  List<String> roomNoData = [];
  String? selectedRoomNo;
  String? roomTypeSaving;

  // Controllers for the input fields
  final TextEditingController guestNameController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController rentController = TextEditingController();
  final TextEditingController advanceController = TextEditingController();

  DateTime? checkInDate;
  DateTime? checkOutDate;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchRoomNumbers();
  }

  Future<void> fetchRoomNumbers() async {
    try {
      final response = await http.get(
        Uri.parse('http://wsdb01/APITesting/api/Users/getroomnooccupied'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          roomNoData = data.map((room) => room['roomNo'].toString()).toList();
        });
      } else {
        logger.d("Failed to fetch room numbers: ${response.statusCode}");
      }
    } catch (e) {
      logger.d("Error fetching room numbers: $e");
    }
  }

  Future<void> fetchRoomDetails(String roomNo) async {
    try {
      final roomTypeResponse = await http.get(
        Uri.parse('http://wsdb01/APITesting/api/Users/getroomnotype?id=$roomNo'),
      );

      if (roomTypeResponse.statusCode == 200) {
        final roomTypeData = json.decode(roomTypeResponse.body);
        setState(() {
          roomTypeSaving = roomTypeData['roomType'].toString();
        });
      } else {
        logger.d("Failed to fetch room type: ${roomTypeResponse.statusCode}");
      }

      final detailsResponse = await http.get(
        Uri.parse('http://wsdb01/APITesting/api/Users/$roomNo'),
      );

      if (detailsResponse.statusCode == 200) {
        final detailsData = json.decode(detailsResponse.body);
        setState(() {
          guestNameController.text = detailsData['guestName'] ?? '';
          phoneNoController.text = detailsData['phoneNo'] ?? '';
          addressController.text = detailsData['address'] ?? '';
          purposeController.text = detailsData['purpose'] ?? '';
          rentController.text = detailsData['rent']?.toString() ?? '';
          advanceController.text = detailsData['advance']?.toString() ?? '';
          checkInDate = DateTime.parse(detailsData['checkInDate'] ?? DateTime.now().toString());
          checkOutDate = DateTime.parse(detailsData['checkOutDate'] ?? DateTime.now().toString());
        });
      } else {
        logger.d("Failed to fetch room details: ${detailsResponse.statusCode}");
      }
    } catch (e) {
      logger.d("Error fetching room details: $e");
    }
  }

  Future<void> saveData() async {
    if (!_formKey.currentState!.validate()) return;

    final response = await http.post(
      Uri.parse('http://wsdb01/APITesting/api/Users/checkout'),
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
        "cout_extras": 0,
        "cout_refund": 0,
      }),
    );

    if (response.statusCode == 200) {
      logger.d("Data saved successfully!");
      // Handle success (e.g., show a success message, navigate back, etc.)
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data saved successfully!")));
    } else {
      logger.d("Failed to save data. Status code: ${response.statusCode}");
      // Handle error (e.g., show an error message)
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to save data.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isWideScreen = MediaQuery.of(context).size.width > 500;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Check Out Data"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Form(
          key: _formKey,
          child: isWideScreen
              ? const Center(child: Text("Laptop"))
              : Column(
                  children: [
                    Row(
                      children: [
                        const Text("Room NO"),
                        const SizedBox(width: 20),
                        DropdownButton(
                          value: selectedRoomNo,
                          items: roomNoData.map((String roomNo) {
                            return DropdownMenuItem(
                              value: roomNo,
                              child: Text(roomNo),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedRoomNo = newValue;
                              fetchRoomDetails(newValue!);
                              logger.d("Selected Room NO: $newValue");
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter guest name';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: phoneNoController,
                            decoration: const InputDecoration(labelText: "Phone No"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter phone number';
                              }
                              return null;
                            },
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
                            controller: TextEditingController(
                              text: checkInDate?.toLocal().toString().split(' ')[0],
                            ),
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
                            controller: TextEditingController(
                              text: checkOutDate?.toLocal().toString().split(' ')[0],
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(labelText: "Address"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter address';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: purposeController,
                      decoration: const InputDecoration(labelText: "Purpose of Visit"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter purpose';
                        }
                        return null;
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: rentController,
                            decoration: const InputDecoration(labelText: "Rent"),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter rent';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: advanceController,
                            decoration: const InputDecoration(labelText: "Advance"),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter advance';
                              }
                              return null;
                            },
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
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
