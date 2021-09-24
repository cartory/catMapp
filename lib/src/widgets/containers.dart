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
