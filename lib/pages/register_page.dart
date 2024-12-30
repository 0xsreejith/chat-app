import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  void Function()? onTap;

  RegisterPage({super.key, required this.onTap});
  void register(BuildContext context) async {
    // Check if fields are empty
    if (emailController.text.isEmpty || passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    final email = emailController.text.trim();
    final password = passController.text.trim();

    // Validate email format
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid email format")),
      );
      return;
    }

    // Validate password strength (at least 6 characters)
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password must be at least 6 characters")),
      );
      return;
    }

    // Proceed with authentication
    final auth = AuthService();
    final chatService = ChatService();
    try {
      await auth.signUpWithEmailAndPassword(email, password);
      final currentUser = auth.getCurrentUser();
      if (currentUser != null) {
        final userData = {
          'email': currentUser.email,
          'username': currentUser.email?.split('@')[0]
        };
        await chatService.addUser(userData);
      }
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Account created successfully. Please log in.")),
      );

      // Navigate to LoginPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(onTap: onTap),
        ),
      );
    } catch (e) {
      // Handle error if registration fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration failed: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Icon(Icons.message,
                color: Theme.of(context).colorScheme.primary, size: 60),
            const SizedBox(height: 40),

            // Welcome text
            Text("Let's create an account for you",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16)),
            const SizedBox(height: 20),

            // Email and Password Textfields
            MyTextfield(
              hintText: "Email",
              isObsecure: false,
              controller: emailController,
            ),
            const SizedBox(height: 10),
            MyTextfield(
              hintText: "Password",
              isObsecure: true,
              controller: passController,
            ),
            const SizedBox(height: 15),

            // Register Button
            MyButton(
              data: "Register",
              onTap: () => register(context),
            ),
            const SizedBox(height: 15),

            // Already have an account
            Padding(
              padding: const EdgeInsets.only(right: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Already have an account?  ",
                    style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      "Login Now",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
