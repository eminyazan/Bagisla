
import 'package:bagisla/model/ad/ad_model.dart';
import 'package:bagisla/model/message/message.dart';
import 'package:bagisla/model/message/speech.dart';
import 'package:bagisla/model/user/user_model.dart';

abstract class DBBase{
  Future<void>initializeDB();
  Future<UserModel?>readUserFromDB(String uid);
  Future<bool>saveUserToDB(UserModel user);
  Future<bool>saveAdToDB(AdModel ad,String userId);
  Future<bool>updatePaymentStatus(String adId);
  Future<List<AdModel>?>getUserAdsFromDB(String userUid);
  Future<List<AdModel>?>getAllAds();
  Future<List<Speech>?> getAllConversations(String userID);
  Stream<List<Speech>> getAllConversationsStream(String userID);
  Future<bool> saveMessage(Message saveMessage);
  Stream<List<Message>>getMessageWithPagination(String currentUserID, String chattedUserID, String? lastMessage);
  Future<void> updateSeen(String chattedUserUid, String userUid);
  Future<List<AdModel>?> search(String text);
  Future<void> updateUserField(String uid,String field,Object value);
}