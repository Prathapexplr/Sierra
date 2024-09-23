import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:practicing/Room%20List/controller/room_list_api_ctroller.dart';
import 'package:practicing/Room%20List/model/room_list_model.dart';

class RoomListScreen extends StatefulWidget {
  const RoomListScreen({super.key});

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  bool isLoadingRoomList = true;

  List<RoomModel> roomListData = [];

  var logger = Logger();

  @override
  void initState() {
    super.initState();
    fetchRoomList();
  }

  Future<void> fetchRoomList() async {
    try {
      roomListData = await RoomListApiCtroller().fetchRoomList();

      setState(() {
        isLoadingRoomList = false;
      });
    } catch (e) {
      logger.d("Error $e");
      setState(() {
        isLoadingRoomList = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Room Listing"),
      ),
      body: isLoadingRoomList
          ? const CircularProgressIndicator()
          : roomListData.isEmpty
              ? const Text("No Data in the API")
              : SingleChildScrollView(
                  child: DataTable(
                      columns: const [
                        DataColumn(label: Text("1")),
                        DataColumn(label: Text("2"))
                      ],
                      rows: roomListData.map((room) {
                        return DataRow(cells: [
                          DataCell(Text(room.shipName.toString())),
                          DataCell(Text(room.shipAddress.toString()))
                        ]);
                      }).toList()),
                ),
    );
  }
}
