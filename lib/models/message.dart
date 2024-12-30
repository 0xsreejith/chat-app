import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String senderEmail;
  final String receiverID;
  final String message;
  final Timestamp timestamp;

  // Constructor
  Message(
    this.message,
    this.timestamp, {
    required this.senderID,
    required this.senderEmail,
    required this.receiverID,
  });

  // Convert Message object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderEmail': senderEmail,
      'receiverID': receiverID,
      'message': message, 
      'timestamp': timestamp,
    };
  }

  // Factory constructor to create a Message object from Firestore data
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      map['message'],
      map['timestamp'],
      senderID: map['senderID'],
      senderEmail: map['senderEmail'],
      receiverID: map['receiverID'],
    );
  }
}
