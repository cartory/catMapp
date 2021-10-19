import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:rounded_expansion_tile/rounded_expansion_tile.dart';

import 'package:catmapp/src/globals.dart' show GetPlace, Place, ButtonCard, LabelIconButton;

const typeIcons = {
  'office': Icons.event_seat_rounded,
  'classroom': Icons.class__outlined,
  'university': Icons.school_rounded,
  'faculty': Icons.account_balance_rounded,
  'module': Icons.local_convenience_store_sharp,
};

class PlaceScreen extends StatefulWidget {
  const PlaceScreen({Key? key}) : super(key: key);

  @override
  _PlaceScreenState createState() => _PlaceScreenState();
}

class _PlaceScreenState extends State<PlaceScreen> {
  int selectedPlace = 0;
  bool isLoadingChildren = false;
  final getPlace = Get.find<GetPlace>();

  @override
  void initState() {
    super.initState();
    getPlace.findAll(refresh: true).whenComplete(() => setState(() => Null));
  }

  @override
  Widget build(BuildContext context) {
    final slivers = <Widget>[
      const SliverAppBar(
        centerTitle: true,
        title: Text('Places'),
      )
    ];

    return Obx(() {
      if (getPlace.places.isEmpty) {
        slivers.add(reloadSliver());
      } else {
        slivers.addAll([
          horizontalSliver(getPlace.places),
          isLoadingChildren ? reloadSliver() : verticalSliver(getPlace.places[selectedPlace].places),
        ]);
      }
      return RefreshIndicator(
        color: Get.theme.colorScheme.secondary,
        child: CustomScrollView(slivers: slivers),
        onRefresh: () => getPlace.findAll(refresh: true).whenComplete(() {
          setState(() => selectedPlace = 0);
        }),
      );
    });
  }

  Widget reloadSliver() {
    return const SliverFillRemaining(
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 3,
          color: Color(0xff383D4A),
        ),
      ),
    );
  }

  Widget verticalSliver(List<Place>? places) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final place = places![index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Card(
              elevation: 1,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
              child: RoundedExpansionTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
                title: Text('${place.type!.name.toString().capitalize} ${place.code}'),
                subtitle: Text(place.name.toString()),
                minLeadingWidth: 30,
                leading: SizedBox(
                  height: double.infinity,
                  child: Icon(typeIcons[place.type!.name], size: 30),
                ),
                trailing: const SizedBox(
                  height: double.infinity,
                  child: Icon(Icons.chevron_right_sharp, size: 25),
                ),
                childrenPadding: const EdgeInsets.all(10),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: CachedNetworkImage(
                      height: 150,
                      imageUrl: 'https://i.pinimg.com/736x/6c/92/22/6c922234c15e5d66a3c4ff659cef95d5.jpg',
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          margin: EdgeInsets.zero,
                          padding: EdgeInsets.zero,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                            image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      place.description.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  // const Divider(indent: 30, endIndent: 30),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      LabelIconButton(iconData: Icons.edit, label: 'edit', onPressed: () {}),
                      LabelIconButton(iconData: Icons.task, label: 'tasks', onPressed: () {}),
                      LabelIconButton(iconData: Icons.inventory, label: 'stock', onPressed: () {}),
                      LabelIconButton(
                        iconData: Icons.more,
                        label: 'more',
                        onPressed: () {
                          setState(() => getPlace.places.clear());
                          getPlace.replaceAll(places.toList(), index).whenComplete(() {
                            setState(() => selectedPlace = index);
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        childCount: places?.length ?? 0,
      ),
    );
  }

  Widget horizontalSliver(List<Place>? places) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.zero,
        height: Get.height / 5.25,
        child: SlideInRight(
          duration: const Duration(milliseconds: 250),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            itemCount: places!.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final place = places[index];
              return ButtonCard(
                elevation: 2,
                height: Get.height / 5.25,
                borderRadius: BorderRadius.circular(20),
                isPressed: index == selectedPlace,
                shadowColor: Colors.primaries[selectedPlace % Colors.primaries.length].shade100,
                onPressed: () {
                  if (index != selectedPlace) {
                    selectedPlace = index;
                    setState(() => isLoadingChildren = true);
                    getPlace.findOne(place.id!.toInt(), index).whenComplete(() {
                      setState(() => isLoadingChildren = false);
                    });
                  }
                },
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
      ),
    );
  }
}
