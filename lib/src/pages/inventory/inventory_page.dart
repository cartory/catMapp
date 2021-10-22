import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:catmapp/src/globals.dart';

class InventoryPage extends GetView<GetEquipment> {
  const InventoryPage({Key? key}) : super(key: key);

  Widget verticalSliver() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final equipment = controller.equipments[index];

          return Card(
            elevation: 1,
            margin: const EdgeInsets.symmetric(vertical: .1),
            child: ListTile(
              // borderRadius: BorderRadius.zero,
              // title: equipment.code.toString(),
              tileColor: Colors.white,
              leading: const Icon(Icons.article),
              title: Text(equipment.code.toString()),
              // margin: const EdgeInsets.symmetric(vertical: .1),
            ),
          );
        },
        childCount: controller.equipments.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Inventory ${controller.place.code ?? ''}'),
        actions: [
          IconButton(
            icon: Icon(Icons.download, color: Get.theme.colorScheme.secondary),
            onPressed: () {},
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Obx(
        () {
          final slivers = <Widget>[];

          try {
            if (controller.isLoading) {
              slivers.add(const SliverReload());
            } else {
              if (controller.equipments.isEmpty) {
                slivers.add(const SliverError(message: 'No Data Found', iconData: Icons.storage_rounded));
              } else {
                slivers.add(verticalSliver());
                slivers.addIf(controller.isNextPage, const SliverReload(height: 100));
              }
            }
          } catch (e) {
            slivers.add(const SliverError());
          }

          return RefreshIndicator(
            color: Get.theme.colorScheme.secondary,
            onRefresh: () async => controller.refresh(),
            child: CustomScrollView(
              slivers: slivers,
              controller: controller.scrollController,
            ),
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
