import 'package:chat_app/models/message.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String reciverEmail;
  final String reciverID;

  const ChatPage({Key? key, required this.reciverEmail, required this.reciverID}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void sendMessages() async {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      try {
        await chatService.sendMessage(widget.reciverID, message);
        _messageController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to send message: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.reciverEmail),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessages,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    final senderID = authService.getCurrentUser()?.uid;
    if (senderID == null) {
      return Center(child: Text("User not logged in"));
    }

    final chatRoomID = chatService.generateChatRoomID(senderID, widget.reciverID);
    
    return StreamBuilder<List<Message>>(
      stream: chatService.getMessageStream(chatRoomID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No messages yet"));
        }

        final messages = snapshot.data!;
        return ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            final isSentByCurrentUser = message.senderID == senderID;

            return Align(
              alignment: isSentByCurrentUser
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSentByCurrentUser ? Colors.blue : Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.message,
                      style: TextStyle(
                        color: isSentByCurrentUser ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      message.timestamp.toDate().toString(),
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

