import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String fromWho;
  String who;
  bool fromMe;
  String message;
  DateTime? date;
  String chattedUserName;
  String chattedUserProfileUrl;

  Message({
    this.date,
    required this.fromWho,
    required this.who,
    required this.fromMe,
    required this.message,
    required this.chattedUserName,
    required this.chattedUserProfileUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'fromWho': fromWho,
      'who': who,
      'fromMe': fromMe,
      'message': message,
      'chattedUserName': chattedUserName,
      'chattedUserProfileUrl': chattedUserProfileUrl,
      'date': date ?? FieldValue.serverTimestamp(),
    };
  }

  Message.fromMap(Map<String, dynamic> map)
      : fromWho = map['fromWho'],
        who = map['who'],
        fromMe = map['fromMe'],
        message = map['message'],
        chattedUserName = map['chattedUserName'],
        chattedUserProfileUrl = map['chattedUserProfileUrl'],
        date = (map['date'] as Timestamp).toDate();

  @override
  String toString() {
    return 'Message{fromWho: $fromWho, who: $who, fromMe: $fromMe, message: $message, date: $date chattedUserName:$chattedUserName chattedUserProfileUrl: $chattedUserProfileUrl}';
  }
}
