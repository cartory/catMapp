import 'package:flutter/widgets.dart';
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

          return MyListTile(
            leading: controller.isModeSelected
                ? Transform.scale(
                    scale: 1.25,
                    child: Checkbox(
                      value: equipment.isSelected,
                      activeColor: Get.theme.colorScheme.secondaryVariant,
                      onChanged: (value) => controller.setChecked(index, value!),
                    ),
                  )
                : const Icon(Icons.inbox, size: 27),
            borderRadius: BorderRadius.zero,
            margin: const EdgeInsets.symmetric(vertical: .1),
            onLongPress: () {
              controller.isModeSelected = !controller.isModeSelected;
            },
            title: equipment.code.toString(),
            subtitle: Text.rich(TextSpan(
              text: 'UNIT:',
              style: const TextStyle(fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: '${equipment.unit!.name}\t\t\t\t',
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
                TextSpan(text: 'STATE: ', children: [
                  TextSpan(text: '${equipment.state}', style: const TextStyle(fontWeight: FontWeight.normal)),
                ]),
              ],
            )),
            imageUrl: 'https://i.pinimg.com/736x/6c/92/22/6c922234c15e5d66a3c4ff659cef95d5.jpg',
            imageDescription: Text(
              equipment.description.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            options: [
              LabelIconButton(iconData: Icons.edit_rounded, label: 'edit', onPressed: () {}),
              LabelIconButton(iconData: Icons.compare_arrows_rounded, label: 'moves', onPressed: () {}),
              LabelIconButton(iconData: Icons.info_rounded, label: 'info', onPressed: () {}),
            ],
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
          ),
        ],
      ),
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
        onPressed: () async {
          await showSearch(context: context, delegate: SearchEquipment(controller.place));
        },
      ),
    );
  }
}
