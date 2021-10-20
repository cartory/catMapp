import 'package:flutter/material.dart';

class MyFloatingActionButton extends StatefulWidget {
  final IconData? iconData;
  final void Function()? onPressed;

  const MyFloatingActionButton({
    Key? key,
    @required this.iconData,
    @required this.onPressed,
  }) : super(key: key);

  @override
  State<MyFloatingActionButton> createState() => _MyFloatingActionButtonState();
}

class _MyFloatingActionButtonState extends State<MyFloatingActionButton> with SingleTickerProviderStateMixin {
  late final Animation<double> animation;
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();

    animation = Tween<double>(begin: 0, end: 1).animate(
      controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 150)),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: child,
        );
      },
      child: FloatingActionButton(
        child: Icon(widget.iconData),
        onPressed: widget.onPressed,
      ),
    );
  }
}

class LabelIconButton extends StatelessWidget {
  final String? label;
  final IconData? iconData;
  final void Function()? onPressed;

  const LabelIconButton({
    Key? key,
    this.label,
    @required this.iconData,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        overlayColor: MaterialStateColor.resolveWith((states) {
          return const Color(0x55DCE1E6);
        }),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(1),
            child: Icon(
              iconData,
              color: const Color(0xff383D4A),
              size: 25,
            ),
          ),
          Text(
            label.toString(),
            style: const TextStyle(
              color: Color(0xff383D4A),
            ),
          ),
        ],
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
          color: isPressed ? Colors.grey[200] : color,
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
