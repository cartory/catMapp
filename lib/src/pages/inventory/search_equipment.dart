// ignore_for_file: file_names
import 'dart:async';

import 'package:get/get.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';

import 'package:catmapp/src/globals.dart';
import 'package:catmapp/src/utils/debouncer.dart';

class SearchEquipment extends SearchDelegate<Equipment> {
  late final Debouncer<String> _debouncer;

  final _scrollController = ScrollController();

  final _selectedController = StreamController<bool>.broadcast();
  final _equipmentController = StreamController<List<Equipment>>.broadcast();

  Stream<List<Equipment>> get stream => _equipmentController.stream;
  void Function(List<Equipment>) get sink => _equipmentController.sink.add;

  Stream<bool> get selectedStream => _selectedController.stream;
  void Function(bool) get sinkSelected => _selectedController.sink.add;

  Place? place;
  int _page = 0;

  @override
  ThemeData appBarTheme(BuildContext context) => Get.theme;

  SearchEquipment([this.place]) {
    _scrollController.addListener(() async {
      if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
        _page++;
        final newData = await EquipmentApi.findAll(page: _page, query: _debouncer.value);

        if (newData.isNotEmpty) {
          sink(newData);
        }
      }
    });

    _debouncer = Debouncer<String>(
      duration: const Duration(milliseconds: 500),
      onValue: (value) async {
        sink(await EquipmentApi.findAll(page: _page, query: value, placeId: place?.id));
      },
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear_rounded),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () => close(context, Equipment()),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    _debouncer.value = query.trim();
    return getQuerySuggestions();
  }

  Widget getQuerySuggestions() {
    return StreamBuilder2<bool, List<Equipment>>(
      streams: Tuple2(selectedStream, stream),
      builder: (_, snap) {
        if (snap.item2.hasError) {
          return const Placeholder();
        }

        if (!snap.item2.hasData) {
          return Center(
            child: Transform.scale(
              scale: .75,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Get.theme.colorScheme.secondary,
              ),
            ),
          );
        }

        if (snap.item2.data!.isEmpty) {
          return Center(
            child: Text(
              'No Data Found 🔍!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Get.theme.colorScheme.secondary),
            ),
          );
        }

        return ListView.builder(
          itemCount: snap.item2.data!.length,
          controller: _scrollController,
          itemBuilder: (context, index) {
            final equipment = snap.item2.data![index];
            final selectedMode = snap.item1.data ?? false;

            return MyListTile(
              borderRadius: BorderRadius.zero,
              leading: selectedMode
                  ? Transform.scale(
                      scale: 1.25,
                      child: Checkbox(
                        value: equipment.isSelected,
                        activeColor: Get.theme.colorScheme.secondaryVariant,
                        onChanged: (value) {
                          snap.item2.data![index] = equipment..isSelected = value!;
                          sink(snap.item2.data!.toList());
                        },
                      ),
                    )
                  : const Icon(Icons.inbox, size: 27),
              margin: const EdgeInsets.symmetric(vertical: .1),
              title: equipment.code.toString(),
              onLongPress: () => sinkSelected(!selectedMode),
              subtitle: Text.rich(TextSpan(
                text: 'UNIT: ',
                style: const TextStyle(fontWeight: FontWeight.bold),
                children: [
                  TextSpan(text: '${equipment.unit!.name}\t\t\t\t', style: const TextStyle(fontWeight: FontWeight.normal)),
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
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      _debouncer.value = query.trim();
      return getQuerySuggestions();
    }

    return Center(
      child: Text(
        'Search 🔍!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 25, color: Get.theme.colorScheme.secondary),
      ),
    );
  }

  @override
  void close(BuildContext context, Equipment result) {
    _scrollController.dispose();
    // _equipmentController.close();
    super.close(context, result);
  }
}
