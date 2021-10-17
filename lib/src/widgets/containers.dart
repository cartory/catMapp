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
    return Transform.translate(
      offset: const Offset(0, 15),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          child: BottomNavigationBar(
            elevation: 0,
            items: widget.items,
            onTap: widget.onTap,
            currentIndex: widget.currentIndex,
          ),
        ),
      ),
    );
  }
}

class ButtonCard extends StatelessWidget {
  final BorderRadius? borderRadius;
  final void Function()? onPressed;

  final List<Widget> children;

  final bool isPressed;
  final double? height;
  final double? elevation;

  final Color? color;
  final Color? shadowColor;

  const ButtonCard({
    Key? key,
    this.color,
    this.height,
    this.elevation,
    this.onPressed,
    this.shadowColor,
    this.borderRadius,
    this.isPressed = false,
    this.children = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: height,
      height: height,
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
      ),
      child: InkWell(
        onTap: onPressed,
        autofocus: isPressed,
        borderRadius: borderRadius,
        splashFactory: InkRipple.splashFactory,
        child: Card(
          shadowColor: shadowColor,
          elevation: isPressed ? 0 : elevation,
          color: isPressed ? Colors.grey[50] : color,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.zero,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        ),
      ),
    );
  }
}
