
import 'package:cloud_firestore/cloud_firestore.dart';

class Speech {
  String messageOwner;
  String chatWith;
  String lastMessage;
  bool seen;
  DateTime lastMessageDate;
  DateTime? seenDate;
  String chattedUserName;
  String chattedUserProfileUrl;

  Speech({
    this.seenDate,
    required this.messageOwner,
    required this.chatWith,
    required this.lastMessage,
    required this.seen,
    required this.lastMessageDate,
    required this.chattedUserName,
    required this.chattedUserProfileUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'messageOwner': messageOwner,
      'chatWith': chatWith,
      'lastMessage': lastMessage,
      'seen': seen,
      'createDate': lastMessageDate,
      'seenDate': seenDate,
      'chattedUserName': chattedUserName,
      'chattedUserProfileUrl': chattedUserProfileUrl,
    };
  }

  Speech.fromMap(Map<String, dynamic> map)
      : messageOwner = map['messageOwner'],
        chatWith = map['chatWith'],
        lastMessage = map['lastMessage'],
        seen = map['seen'],
        lastMessageDate = (map['createDate'] as Timestamp).toDate(),
        seenDate = (map['seenDate']!=null?(map['seenDate']as Timestamp).toDate():null),
        chattedUserName = map['chattedUserName'],
        chattedUserProfileUrl = map['chattedUserProfileUrl'];

}
