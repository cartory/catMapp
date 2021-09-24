import 'package:flutter/material.dart';

import 'package:get/get.dart';

class MyTextField extends StatefulWidget {
  final String? hintText;
  final String? initialValue;

  final bool hiddenText;
  final TextAlign textAlign;
  final TextInputType? keyboardType;

  final Widget? prefixIcon;

  final EdgeInsetsGeometry? margin;

  final void Function(String)? onChanged;
  final String? Function(String?)? validator;

  const MyTextField({
    Key? key,
    this.margin,
    this.hintText,
    this.validator,
    this.onChanged,
    this.hiddenText = false,
    this.initialValue,
    this.keyboardType,
    this.textAlign = TextAlign.start,
    this.prefixIcon
  }) : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _showClearIcon = false;
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
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
        initialValue: widget.initialValue,
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
                    _textController.clear();
                    setState(() => _showClearIcon = false);
                  },
                )
              : null,
        ),
      ),
    );
  }
}
