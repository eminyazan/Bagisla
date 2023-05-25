import 'package:bagisla/model/ad/ad_model.dart';
import 'package:bagisla/model/message/message.dart';
import 'package:bagisla/model/message/speech.dart';
import 'package:bagisla/model/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../bases/db/db_base.dart';

class DBService extends DBBase {
  static final DBService _dbService = DBService._internal();

  factory DBService() {
    return _dbService;
  }

  DBService._internal();

  final _fireStore = FirebaseFirestore.instance;

  @override
  Future<UserModel?> readUserFromDB(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> snap = await _fireStore.collection("users").doc(uid).get();
    return snap.data() != null ? UserModel.fromMap(snap.data()!) : null;
  }

  @override
  Future<bool> saveUserToDB(UserModel user) async {
    await _fireStore.collection("users").doc(user.uid).set(user.toMap());
    return true;
  }

  @override
  Future<void> initializeDB() async {
    await Firebase.initializeApp();
  }

  @override
  Future<bool> saveAdToDB(AdModel ad, String userId) async {
    await _fireStore.collection("ads").doc(ad.uid).set(ad.toMap());
    await _fireStore.collection("users").doc(userId).update({
      "ads": FieldValue.arrayUnion([ad.uid])
    });
    return true;
  }

  @override
  Future<List<AdModel>?> getUserAdsFromDB(String userUid) async {
    List<AdModel> ads = [];

    QuerySnapshot<Map<String, dynamic>> querySnap = await _fireStore
        .collection("ads")
        .where("ownerUid", isEqualTo: userUid)
        .orderBy("date", descending: true)
        .get();

    for (var element in querySnap.docs) {
      AdModel ad = AdModel.fromMap(element.data());
      ads.add(ad);
    }
    return ads.isNotEmpty ? ads : null;
  }

  @override
  Future<bool> updatePaymentStatus(String adId) async {
    await _fireStore.collection("ads").doc(adId).update({"payed": true});
    return true;
  }

  @override
  Future<List<AdModel>?> getAllAds() async {
    List<AdModel> ads = [];

    QuerySnapshot<Map<String, dynamic>> querySnap =
        await _fireStore.collection("ads").orderBy("date", descending: true).get();

    for (var element in querySnap.docs) {
      AdModel ad = AdModel.fromMap(element.data());
      ads.add(ad);
    }
    return ads.isNotEmpty ? ads : null;
  }

  @override
  Future<List<Speech>?> getAllConversations(String userID) async {
    List<Speech> allConversations = [];
    var snapShot = await _fireStore
        .collection("speeches")
        .where("messageOwner", isEqualTo: userID)
        .orderBy("createDate", descending: true)
        .get();

    for (var element in snapShot.docs) {
      Speech ad = Speech.fromMap(element.data());
      allConversations.add(ad);
    }
    return allConversations.isNotEmpty ? allConversations : null;
  }

  @override
  Stream<List<Speech>> getAllConversationsStream(String userID) {
    Stream<QuerySnapshot<Map<String, dynamic>>> snapShot = _fireStore
        .collection("speeches")
        .where("messageOwner", isEqualTo: userID)
        .orderBy("createDate", descending: true)
        .snapshots();

    return snapShot.map((conversationList) =>
        conversationList.docs.map((conversation) => Speech.fromMap(conversation.data())).toList());
  }

  @override
  Future<bool> saveMessage(Message saveMessage) async {
    var messageID = _fireStore.collection("speeches").doc().id;
    var myDocID = "${saveMessage.fromWho}--${saveMessage.who}";
    var receiverDocID = "${saveMessage.who}--${saveMessage.fromWho}";
    var saveMessageToMap = saveMessage.toMap();
    await _fireStore
        .collection("speeches")
        .doc(myDocID)
        .collection("messages")
        .doc(messageID)
        .set(saveMessageToMap);
    await _fireStore.collection("speeches").doc(myDocID).set({
      "messageOwner": saveMessage.fromWho,
      "chatWith": saveMessage.who,
      "lastMessage": saveMessage.message,
      "seen": true,
      "createDate": FieldValue.serverTimestamp(),
      "chattedUserName": saveMessage.chattedUserName,
      "chattedUserProfileUrl": saveMessage.chattedUserProfileUrl,
    });

    saveMessageToMap.update("fromMe", (value) => false);
    await _fireStore
        .collection("speeches")
        .doc(receiverDocID)
        .collection("messages")
        .doc(messageID)
        .set(saveMessageToMap);
    await FirebaseFirestore.instance.collection("speeches").doc(receiverDocID).set({
      "messageOwner": saveMessage.who,
      "chatWith": saveMessage.fromWho,
      "lastMessage": saveMessage.message,
      "seen": false,
      "createDate": FieldValue.serverTimestamp(),
      "chattedUserName": saveMessage.chattedUserName,
      "chattedUserProfileUrl": saveMessage.chattedUserProfileUrl,
    });

    return true;
  }

  @override
  Stream<List<Message>> getMessageWithPagination(
      String currentUserID, String chattedUserID, String? lastMessage) {
    Stream<QuerySnapshot<Map<String, dynamic>>> querySnapshot;
    if (lastMessage == null) {
      querySnapshot = _fireStore
          .collection("speeches")
          .doc("$currentUserID--$chattedUserID")
          .collection("messages")
          .orderBy("date", descending: true)
          .limit(21)
          .snapshots();
    } else {
      querySnapshot = _fireStore
          .collection("speeches")
          .doc("$currentUserID--$chattedUserID")
          .collection("messages")
          .orderBy("date", descending: true)
          .startAfter([lastMessage])
          .limit(21)
          .snapshots();
    }
    return querySnapshot.map((conversationList) =>
        conversationList.docs.map((conversation) => Message.fromMap(conversation.data())).toList());
  }

  @override
  Future<void> updateSeen(String chattedUserUid, String userUid) async {
    var myDocID = "$userUid--$chattedUserUid";
    await _fireStore.collection("speeches").doc(myDocID).update({
      "seen": true,
    });
  }

  @override
  Future<List<AdModel>?> search(String text) async {
    List<AdModel> ads = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _fireStore.collection("ads").where("description", isGreaterThanOrEqualTo: text).get();
    if (querySnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot<Map<String, dynamic>> element in querySnapshot.docs) {
        AdModel ad = AdModel.fromMap(element.data());
        ads.add(ad);
      }
      return ads.isEmpty ? null : ads;
    } else {
      return null;
    }
  }

  @override
  Future<void> updateUserField(String uid, String field, Object value) async {
    await _fireStore.collection("users").doc(uid).update({field: value});
  }
}
