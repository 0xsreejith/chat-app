import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final String hintText;
  final bool isObsecure;
  final TextEditingController controller;
  const MyTextfield({super.key, required this.hintText, required this.isObsecure, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: isObsecure,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
            fillColor: Theme.of(context).colorScheme.secondary,
            filled: true,
            enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.tertiary)),
            focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.tertiary))),
      ),
    );
  }
}
