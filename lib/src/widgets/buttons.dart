import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:rounded_expansion_tile/rounded_expansion_tile.dart';

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

  const ButtonCard({
    Key? key,
    this.color,
    this.height,
    this.elevation,
    this.onPressed,
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
        color: isPressed ? const Color(0xff383D4A).withOpacity(.03) : null,
        borderRadius: borderRadius,
      ),
      child: InkWell(
        onTap: onPressed,
        autofocus: isPressed,
        borderRadius: borderRadius,
        splashFactory: InkRipple.splashFactory,
        child: Card(
          shadowColor: const Color(0xff383D4A).withOpacity(.5),
          elevation: isPressed ? 0 : elevation,
          color: isPressed ? Colors.grey[150] : color,
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

class MyListTile extends StatelessWidget {
  final String title;
  final String? subtitle;

  final double? elevation;
  final IconData? leadingIcon;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;

  final String? imageUrl;
  final String? imageDescription;
  final List<LabelIconButton>? options;

  const MyListTile({
    Key? key,
    required this.title,
    this.margin,
    this.subtitle,
    this.leadingIcon,
    this.borderRadius,
    this.elevation = 1,
    this.options,
    this.imageUrl,
    this.imageDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    if (imageUrl != null) {
      children.insertAll(0, [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: CachedNetworkImage(
            height: 150,
            imageUrl: imageUrl.toString(),
            imageBuilder: (context, imageProvider) {
              return Container(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                  image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Text(
            imageDescription.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      ]);
    }

    if (options != null) {
      children.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: options ?? [],
        ),
      );
    }

    return Card(
      margin: margin,
      color: Colors.white,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(17),
      ),
      child: RoundedExpansionTile(
        horizontalTitleGap: 20,
        duration: const Duration(milliseconds: 350),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(17),
        ),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle.toString()) : null,
        minLeadingWidth: 30,
        leading: SizedBox(
          height: double.infinity,
          child: Icon(leadingIcon, size: 30),
        ),
        trailing: const SizedBox(
          height: double.infinity,
          child: Icon(Icons.keyboard_arrow_down_rounded, size: 25),
        ),
        childrenPadding: const EdgeInsets.all(10),
        children: children,
      ),
    );
  }
}
