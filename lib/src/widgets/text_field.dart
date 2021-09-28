import 'package:flutter/material.dart';

import 'package:get/get.dart';

class MyTextField extends StatefulWidget {
  final String? hintText;
  final String? initialValue;

  final bool hiddenText;
  final TextAlign textAlign;
  final TextInputType? keyboardType;

  final Widget? prefixIcon;

  final double circularRadius;
  final EdgeInsetsGeometry? margin;

  final void Function()? onClear;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;

  const MyTextField({
    Key? key,
    this.margin,
    this.onClear,
    this.hintText,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.initialValue,
    this.keyboardType,
    this.hiddenText = false,
    this.circularRadius = 15,
    this.textAlign = TextAlign.start,
  }) : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _showClearIcon = false;
  TextEditingController? _textController;

  @override
  void initState() {
    _textController = TextEditingController(text: widget.initialValue);
    super.initState();
  }

  @override
  void dispose() {
    _textController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(widget.circularRadius),
        boxShadow: const [
          BoxShadow(
            blurRadius: 1,
            color: Colors.black12,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: TextFormField(
        key: widget.key,
        cursorWidth: 1.5,
        controller: _textController,
        obscureText: widget.hiddenText,
        cursorColor: const Color(0x33EB008B),
        cursorRadius: const Radius.circular(10),
        textAlign: widget.textAlign,
        validator: widget.validator,
        onChanged: (text) {
          if (_showClearIcon != text.isNotEmpty) {
            setState(() => _showClearIcon = text.isNotEmpty);
          }

          widget.onChanged?.call(text);
        },
        // initialValue: _textController!.text,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          hintText: widget.hintText,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          prefixIcon: widget.prefixIcon,
          suffixIcon: _showClearIcon
              ? InkWell(
                  child: Icon(
                    Icons.clear_rounded,
                    size: 20,
                    color: Get.theme.colorScheme.secondary,
                  ),
                  onTap: () {
                    _textController!.clear();
                    setState(() => _showClearIcon = false);

                    widget.onClear?.call();
                  },
                )
              : null,
        ),
      ),
    );
  }
}
