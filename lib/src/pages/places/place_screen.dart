import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:catmapp/src/config.dart';
import 'package:catmapp/src/globals.dart';

const typeIcons = {
  'office': Icons.event_seat_rounded,
  'classroom': Icons.class__outlined,
  'university': Icons.school_rounded,
  'faculty': Icons.account_balance_rounded,
  'module': Icons.local_convenience_store_sharp,
};

class PlaceScreen extends GetView<GetPlace> {
  const PlaceScreen({Key? key}) : super(key: key);

  Widget horizontalSliver() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.zero,
        width: Get.height / 5.5,
        height: Get.height / 5.5,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          itemCount: controller.places.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final place = controller.places[index];

            return ButtonCard(
              elevation: 2,
              height: Get.height / 5.5,
              borderRadius: BorderRadius.circular(20),
              isPressed: index == controller.selectedIndex,
              onPressed: () => controller.setIndex(index, place.id!.toInt()),
              children: [
                Text(
                  place.type!.name.toString().capitalize ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  place.code ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    typeIcons[place.type!.name],
                    size: 45,
                    color: Get.theme.colorScheme.secondary,
                  ),
                ),
                Text(
                  '${place.places?.length ?? 0} place(s)',
                  textAlign: TextAlign.center,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<LabelIconButton>? getLabelIcons(Place place, int index) {
    final labelIcons = [
      LabelIconButton(
        label: 'edit',
        iconData: Icons.edit_rounded,
        onPressed: () async => await Get.bottomSheet(
          BottomSheet(
            onClosing: () {},
            builder: (_) => PlaceFormSheet(place: place),
          ),
        ),
      ),
      LabelIconButton(iconData: Icons.task_rounded, label: 'tasks', onPressed: () {}),
    ];

    labelIcons.addIf(
      !place.hasPlaces,
      LabelIconButton(
        iconData: Icons.inventory_2_rounded,
        label: 'inventory',
        onPressed: () async {
          GetInstance().find<GetEquipment>().setPlace(place);
          await Get.toNamed<void>(Routes.inventory);
        },
      ),
    );

    labelIcons.addIf(
      place.hasPlaces,
      LabelIconButton(
        label: 'more',
        iconData: Icons.more_rounded,
        onPressed: () => controller.seeMorePlaces(index),
      ),
    );

    return labelIcons;
  }

  Widget verticalSliver() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, index) {
          final place = controller.selectedPlace.places![index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: MyListTile(
              title: '${place.type!.name.toString().capitalize} ${place.code}',
              subtitle: Text(place.name.toString()),
              leading: Icon(typeIcons[place.type!.name], size: 27),
              imageDescription: Text(
                place.description.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              imageUrl: 'https://i.pinimg.com/736x/6c/92/22/6c922234c15e5d66a3c4ff659cef95d5.jpg',
              options: getLabelIcons(controller.selectedPlace.places![index], index),
            ),
          );
        },
        childCount: controller.selectedPlace.places!.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final slivers = <Widget>[
          const SliverAppBar(
            centerTitle: true,
            title: Text('Places'),
          ),
        ];

        try {
          if (controller.isLoading) {
            slivers.add(const SliverReload());
          } else {
            slivers.addAll(
              [
                horizontalSliver(),
                controller.isLoadingChildren ? const SliverReload() : verticalSliver(),
              ],
            );

            slivers.add(const SliverToBoxAdapter(child: SizedBox(height: 50)));
          }
        } catch (e) {
          slivers.add(const SliverError());
        }

        return RefreshIndicator(
          color: Get.theme.colorScheme.secondary,
          onRefresh: () async => controller.refresh(),
          child: CustomScrollView(
            slivers: slivers,
          ),
        );
      },
    );
  }
}
