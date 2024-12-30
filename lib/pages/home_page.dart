import 'package:chat_app/components/my_drawer.dart';
import 'package:chat_app/components/user_tile.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text("HOME"),
      ),
      body: _buildUsersList(),
    );
  }

  Widget _buildUsersList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _chatService.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return _buildUsersListItem(users[index], context);
            },
          );
        }

        return const Center(child: Text("No users available."));
      },
    );
  }

  Widget _buildUsersListItem(
      Map<String, dynamic> userData, BuildContext context) {
    final currentUser = _authService.getCurrentUser();
    final currentUserEmail = currentUser?.email;

    // Ensure currentUser and currentUserEmail are not null
    if (userData['email'] != null &&
        userData['email'] != currentUserEmail) {
      return UserTile(
        text: userData['email'] ?? 'No email',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                reciverID: userData['uid'],
                reciverEmail: userData['email'] ?? 'No email',
              ),
            ),
          );
        },
      );
    } else {
      return Container(); // Or return an empty SizedBox
    }
  }
}
