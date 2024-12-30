import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/settings_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout(BuildContext context) async {
    final authService = AuthService();

    try {
      await authService.signOut();

      // Navigate back to login page after logout
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage(onTap: () {})),
        (route) => false, // Remove all previous routes
      );
    } catch (e) {
      // Handle logout errors (if any)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logout failed: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Icon(
                  Icons.message,
                  size: 40,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text("H O M E "),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("S E T T I N G S"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsPage()),
                  );
                },
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("L O G O U T "),
            onTap: () => logout(context), // Pass context
          ),
        ],
      ),
    );
  }
}
