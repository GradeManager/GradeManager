import 'package:flutter/material.dart';

class gmTextField extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final List<String>? autofillhints;
  final String? hintText;
  final int? maxChars;
  final TextInputType? textInputType;
  final TextAlign textAlign;
  final IconData icon;

  const gmTextField({super.key,this.controller,this.onSubmitted,this.onChanged, this.autofillhints,this.hintText,required this.icon,this.maxChars, this.textInputType, required this.textAlign});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      autofillHints: autofillhints,
      maxLength: maxChars,
      keyboardType: textInputType,
      textAlign: textAlign,
      decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: Color.fromARGB(255, 20, 30, 48),
                  width: 2
              )
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: Color.fromARGB(255, 20, 30, 48),
                  width: 2
              )
          )
      ),
    );
  }
}