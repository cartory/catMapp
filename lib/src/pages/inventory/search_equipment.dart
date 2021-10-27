// ignore_for_file: file_names
import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:catmapp/src/globals.dart';
import 'package:catmapp/src/utils/debouncer.dart';

class SearchEquipment extends SearchDelegate<Equipment> {
  late final Debouncer<String> _debouncer;

  final _scrollController = ScrollController();
  late final _equipmentController = StreamController<List<Equipment>>.broadcast();

  Stream<List<Equipment>> get stream => _equipmentController.stream;
  void Function(List<Equipment>) get sink => _equipmentController.sink.add;

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
      duration: const Duration(milliseconds: 600),
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
    throw const Text('show results');
  }

  Widget getQuerySuggestions() {
    return StreamBuilder<List<Equipment>>(
      stream: stream,
      builder: (_, snap) {
        if (snap.hasError) {
          return const Placeholder();
        }

        if (!snap.hasData) {
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

        if (snap.data!.isEmpty) {
          return Center(
            child: Text(
              'No Data Found 🔍!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Get.theme.colorScheme.secondary),
            ),
          );
        }

        return ListView.builder(
          itemCount: snap.data!.length,
          controller: _scrollController,
          itemBuilder: (context, index) {
            final equipment = snap.data![index];

            return MyListTile(
              leadingIcon: Icons.inbox,
              borderRadius: BorderRadius.zero,
              margin: const EdgeInsets.symmetric(vertical: .1),
              title: equipment.code.toString(),
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
              // imageDescription: equipment.description,
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
      _debouncer.value = query;
      return getQuerySuggestions();
    }

    return Center(
      child: Text(
        'Search 🔍!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, color: Get.theme.colorScheme.secondary),
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
