import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget(
      {Key? key,
      required this.hintText,
      required this.prefixIcon,
      required this.controller,
      required this.validator,
      required this.obscureText})
      : super(key: key);

  final String? hintText;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: TextFormField(
        obscureText: obscureText,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.black26,
          ),
          prefixIcon: prefixIcon,
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
            borderSide: BorderSide(color: Colors.black),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
        controller: controller,
        validator: validator,
      ),
    );
  }
}
