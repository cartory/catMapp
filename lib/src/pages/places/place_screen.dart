import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';

import 'package:catmapp/src/globals.dart' show GetPlace, Place;

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
        onRefresh: () {
          return getPlace.findAll(refresh: true).whenComplete(() {
            setState(() => selectedPlace = 0);
          });
        },
        child: CustomScrollView(slivers: slivers),
      );
    });
  }

  Widget reloadSliver() {
    return const SliverFillRemaining(
      child: CircularProgressIndicator.adaptive(),
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
              elevation: 2,
              shadowColor: Colors.primaries[selectedPlace % Colors.primaries.length].shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                subtitle: Text(place.description.toString()),
                title: Text('${place.type!.name.toString().capitalize} ${place.code}'),
                leading: Transform.translate(
                  offset: const Offset(6, 0),
                  child: Icon(
                    typeIcons[place.type!.name],
                    size: 33,
                    color: Get.theme.colorScheme.secondary,
                  ),
                ),
                onTap: () {
                  setState(() => getPlace.places.clear());
                  getPlace.replaceAll(places.toList(), index).whenComplete(() {
                    setState(() => selectedPlace = index);
                  });
                },
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
              return Container(
                width: Get.height / 5.3,
                margin: const EdgeInsets.all(5),
                child: Tooltip(
                  message: place.name.toString(),
                  child: InkWell(
                    onTap: () async {
                      if (index != selectedPlace) {
                        selectedPlace = index;
                        setState(() => isLoadingChildren = true);
                        getPlace.findOne(place.id!.toInt(), index).whenComplete(() {
                          setState(() => isLoadingChildren = false);
                        });
                      }
                    },
                    child: Card(
                      elevation: 3,
                      shadowColor: Colors.primaries[selectedPlace % Colors.primaries.length].shade100,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                            '${place.places?.length ?? '?'} place(s)',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
