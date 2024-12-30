import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const UserTile({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2, // Add shadow to the card for a floating effect
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Padding around the text
        leading: Icon(Icons.account_circle, color: Colors.blue), // Leading icon
        title: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87, // Text color
          ),
        ),
        onTap: onTap,
        tileColor: Colors.grey[50], // Background color of the tile
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
