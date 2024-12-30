import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add a user to Firestore (no model class, using raw data)
  Future<void> addUser(Map<String, dynamic> userData) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        // Use the user ID as the document ID to store the user data
        await _firestore.collection("Users").doc(userId).set(userData);
        print("User added successfully");
      } else {
        print("User not logged in");
      }
    } catch (e) {
      print("Error adding user: $e");
    }
  }

  // Get User Stream (Return raw data as a list of maps)
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        //go through each intividual user
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  // Send a message to a chat room
  Future<void> sendMessage(String receiverId, String message) async {
    try {
      final currentUserId = _auth.currentUser?.uid;
      final currentUserEmail = _auth.currentUser?.email;

      if (currentUserId == null || currentUserEmail == null) {
        print("User is not logged in.");
        return;
      }

      final Timestamp timestamp = Timestamp.now();
      Message newMessage = Message(
        message,
        timestamp,
        senderID: currentUserId,
        senderEmail: currentUserEmail,
        receiverID: receiverId,
      );

      String chatRoomID = generateChatRoomID(currentUserId, receiverId);

      await _firestore
          .collection("chat_rooms")
          .doc(chatRoomID)
          .collection("messages")
          .add(newMessage.toMap());

      print("Message sent successfully!");
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  // Generate a unique chat room ID based on user IDs
  String generateChatRoomID(String user1, String user2) {
    return user1.hashCode <= user2.hashCode
        ? "$user1\_$user2"
        : "$user2\_$user1";
  }

  // Get the message stream for a specific chat room
  Stream<List<Message>> getMessageStream(String chatRoomID) {
    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Message.fromMap(
            doc.data()); // Convert the document data into Message object
      }).toList();
    });
  }
}
