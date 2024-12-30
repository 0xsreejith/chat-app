import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool isLoading = false;

  // Login method
  void login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passController.text.trim();

    // Input validation
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid email format")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await AuthService().signInWithEmailPasswd(email, password);

      setState(() {
        isLoading = false;
      });

      // Navigate to the home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      emailController.clear();
      passController.clear();

      // Show error using SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    // Logo
                    Icon(
                      Icons.message,
                      color: Theme.of(context).colorScheme.primary,
                      size: 60,
                    ),
                    const SizedBox(height: 40),
                    // Welcome back
                    Text(
                      "Welcome back, you've been missed!",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Email textfield
                    MyTextfield(
                      hintText: "Email",
                      isObsecure: false,
                      controller: emailController,
                    ),
                    const SizedBox(height: 10),
                    // Password textfield
                    MyTextfield(
                      hintText: "Password",
                      isObsecure: true,
                      controller: passController,
                    ),
                    const SizedBox(height: 15),
                    // Login button
                    MyButton(
                      data: "Login",
                      onTap: () => login(context),
                    ),
                    const SizedBox(height: 15),
                    // Register now
                    Padding(
                      padding: const EdgeInsets.only(right: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Not a member?  ",
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: const Text(
                              "Register Now",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
