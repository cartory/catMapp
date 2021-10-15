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
    getPlace.findAll().whenComplete(() => setState(() => Null));
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
      return CustomScrollView(
        slivers: slivers,
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Card(
              elevation: .3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  width: .3,
                  color: Colors.primaries[selectedPlace % Colors.primaries.length].shade100,
                ),
              ),
              child: ListTile(
                subtitle: Text(place.description.toString()),
                title: Text('${place.type!.name.toString().capitalize} ${place.code}'),
                leading: FittedBox(
                  child: Icon(typeIcons[place.type!.name], size: 40),
                ),
                onTap: () {
                  setState(() => getPlace.places.clear());
                  getPlace.replaceAll(places!.toList(), index).whenComplete(() {
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
        height: Get.height / 5.25,
        margin: EdgeInsets.zero,
        child: SlideInRight(
          duration: const Duration(milliseconds: 250),
          child: ListView.builder(
            itemCount: places!.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final place = places[index];
              return Container(
                width: Get.height / 5.3,
                margin: const EdgeInsets.all(5),
                child: InkWell(
                  onTap: () async {
                    if (index != selectedPlace) {
                      setState(() {
                        selectedPlace = index;
                        isLoadingChildren = true;
                      });
                      getPlace.findOne(place.id!.toInt(), index).whenComplete(() {
                        setState(() => isLoadingChildren = false);
                      });
                    }
                  },
                  child: Tooltip(
                    message: place.name.toString(),
                    child: Card(
                      elevation: .3,
                      color: Colors.primaries[index % Colors.primaries.length].shade500,
                      borderOnForeground: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            place.type!.name.toString().capitalize ?? '',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Icon(
                              typeIcons[place.type!.name],
                              color: Colors.white,
                              size: 45,
                            ),
                          ),
                          Text(
                            '${place.places?.length ?? 0} place(s)',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
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
