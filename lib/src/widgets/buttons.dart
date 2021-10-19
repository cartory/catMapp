import 'package:flutter/material.dart';

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
          Icon(iconData, color: const Color(0xff383D4A)),
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
