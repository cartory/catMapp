import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:catmapp/src/globals.dart';
import 'package:catmapp/src/config.dart' show box;

Map<int, Widget? Function()> _getCurrentScreen = {
  0: () => const HomeScreen(),
  3: () => const PlaceScreen(),
  4: () => ProfileScreen(),
  1: () => Container(color: Colors.lightGreen, child: const Center(child: Text('Task Screen'))),
};

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? _user;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _user = User.fromRawJson(box.read<String>('user'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: appBar(),
      body: _getCurrentScreen[_currentIndex]?.call(),
      extendBody: true,
      bottomNavigationBar: MyBottomBar(
        currentIndex: _currentIndex,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          const BottomNavigationBarItem(icon: Icon(Icons.checklist_rounded), label: 'tasks'),
          BottomNavigationBarItem(
            icon: Transform.translate(
              offset: const Offset(0, 8),
              child: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {},
              ),
            ),
            label: '',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.view_module_rounded), label: 'Places'),
          const BottomNavigationBarItem(icon: Icon(Icons.manage_accounts), label: 'Profile'),
        ],
        onTap: (index) {
          if (index != 2 && index != _currentIndex) {
            setState(() => _currentIndex = index);
          }
        },
      ),
    );
  }

  PreferredSizeWidget? appBar() {
    return AppBar(
      leading: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.fromLTRB(8, 8, 0, 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(17),
          child: CachedNetworkImage(
            imageUrl: _user!.photoUrl ?? '',
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
        ),
      ),
      title: Text(
        'Welcome, ${_user?.name}',
        textAlign: TextAlign.start,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 13),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  size: 33,
                ),
                // ignore: avoid_print
                onPressed: () => print('notification tap'),
              ),
              const Positioned(
                top: 23,
                right: 10,
                child: Icon(
                  Icons.brightness_1,
                  size: 14,
                  color: Colors.white,
                ),
              ),
              const Positioned(
                top: 25,
                right: 12,
                child: Icon(
                  Icons.brightness_1,
                  size: 10,
                  color: Color(0xffEB008B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
