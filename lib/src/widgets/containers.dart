import 'package:flutter/material.dart';

class MyContainer extends StatelessWidget {
  final Widget? child;
  const MyContainer({
    Key? key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}

class TextDivider extends StatelessWidget {
  final String? text;
  const TextDivider({
    Key? key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: const Divider(color: Colors.grey, height: 36),
          ),
        ),
        Text(text ?? 'OR'),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: const Divider(color: Colors.grey, height: 36),
          ),
        ),
      ],
    );
  }
}

class MyBottomBar extends StatefulWidget {
  final int currentIndex;
  final void Function(int)? onTap;
  final List<BottomNavigationBarItem> items;

  const MyBottomBar({
    Key? key,
    this.onTap,
    this.items = const [],
    this.currentIndex = 0,
  }) : super(key: key);

  @override
  State<MyBottomBar> createState() => _MyBottomBarState();
}

class _MyBottomBarState extends State<MyBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          items: widget.items,
          onTap: widget.onTap,
          currentIndex: widget.currentIndex,
        ),
      ),
    );
  }
}
