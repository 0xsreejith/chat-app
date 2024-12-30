import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String data;
  void Function()? onTap;
  MyButton({super.key, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.secondary),
          child: Center(
              child: Text(
            data,
            style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary),
          )),
        ),
      ),
    );
  }
}
