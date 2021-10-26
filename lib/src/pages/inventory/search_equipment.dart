import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:catmapp/src/globals.dart';

class SearchEquipment extends SearchDelegate<Equipment> {
  final Equipment? equipment;

  final equipmentApi = EquipmentApi();
  SearchEquipment({this.equipment});

  @override
  ThemeData appBarTheme(BuildContext context) => Get.theme;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        close(context, Equipment());
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('build Results');
  }

  Widget getSuggestions() {
    return StreamBuilder<List<Equipment>>(
      stream: equipmentApi.dataStream,
      builder: (context, snap) {
        if (snap.hasError) {
          return const Center(
            child: Text('Error'),
          );
        }

        if (!snap.hasData) {
          return Center(
            child: Transform.scale(
              scale: .75,
              child: CircularProgressIndicator(strokeWidth: 3, color: Get.theme.colorScheme.secondary),
            ),
          );
        }

        return ListView.builder(
          itemCount: snap.data!.length,
          itemBuilder: (context, index) {
            final equipment = snap.data![index];

            return MyListTile(
              leadingIcon: Icons.inbox,
              borderRadius: BorderRadius.zero,
              margin: const EdgeInsets.symmetric(vertical: .1),
              title: equipment.code.toString(),
              imageUrl: 'https://i.pinimg.com/736x/6c/92/22/6c922234c15e5d66a3c4ff659cef95d5.jpg',
              imageDescription: equipment.description,
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
      equipmentApi.query = query;
      return getSuggestions();
    }

    return Text(query);
  }
}
