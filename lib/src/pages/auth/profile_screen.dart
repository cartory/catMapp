// ignore_for_file: avoid_print

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:catmapp/src/globals.dart' show Auth;

class ProfileScreen extends StatelessWidget {
  final user = Auth.instance.currentUser;

  ProfileScreen({Key? key}) : super(key: key);

  List<List?> get accountSettings {
    return [
      ['Name', user!.name, () => print('asdfasdf')],
      ['Email', user!.email, () => print('asdfasdf')],
      ['Verified Email', user!.verifiedEmail, () => print('asdfasdf')],
      ['Phone Number', user!.phoneNumber, () => print('asdfasdf')],
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listItems = [];

    for (int i = 0; i < accountSettings.length; i++) {
      final row = accountSettings[i];
      listItems.add(
        Card(
          elevation: .3,
          child: ListTile(
            onTap: row![2],
            isThreeLine: false,
            subtitle: Text(row[0]),
            title: Text(row[1] ?? 'Not Found'),
            trailing: const Icon(Icons.navigate_next_rounded),
          ),
        ),
      );
    }

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      children: [
        DrawerHeader(
          child: profilePicture(),
          curve: Curves.easeInCirc,
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 10, 10),
          child: Text(
            'Account Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ListBody(children: listItems),
      ],
    );
  }

  Widget profilePicture() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: EdgeInsets.zero,
          alignment: Alignment.center,
          child: CircleAvatar(
            radius: 65,
            backgroundColor: Colors.white,
            backgroundImage: CachedNetworkImageProvider(user!.photoUrl ?? ''),
          ),
        ),
        Transform.translate(
          offset: const Offset(45, 43),
          child: FloatingActionButton(
            heroTag: 'edit',
            child: const Icon(Icons.mode_edit_outline_rounded, size: 28),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
