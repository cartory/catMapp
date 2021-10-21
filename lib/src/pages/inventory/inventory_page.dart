import 'package:catmapp/src/getX/get_equipment.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:catmapp/src/globals.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class InventoryPage extends StatefulWidget {
  final Place? place;
  const InventoryPage({
    Key? key,
    this.place,
  }) : super(key: key);

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final getEquipment = Get.put(GetEquipment());
  final paginController = PagingController(firstPageKey: 0);
  @override
  void initState() {
    super.initState();
    getEquipment.findAll(refresh: true, placeId: widget.place?.id).whenComplete(() {
      setState(() => Null);
    });
  }

  @override
  void dispose() {
    getEquipment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: getEquipment.equipments.length,
        itemBuilder: (context, index) {
          final place = getEquipment.equipments[index];
          return ListTile(
            title: Text(place.toRawJson()),
          );
        },
      ),
      floatingActionButton: MyFloatingActionButton(
        iconData: Icons.search_rounded,
        onPressed: () {},
      ),
    );
  }
}
