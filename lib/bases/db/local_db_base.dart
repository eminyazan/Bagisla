import 'package:bagisla/model/user/user_model.dart';
import 'package:hive/hive.dart';



abstract class LocalDBBase{
  Future<void> initializeDB();
  Future<Box<UserModel>> openBoxForUser();
  Future<Box<bool>> openBoxForOnBoard();
  Future<bool> saveUserToLocalDB(UserModel user);
  UserModel? readUserFromLocalDB();
  bool readOnBoardFromLocalDB();
  Future<bool> removeFromLocalDB();
  Future<void> saveOnBoardPageVisited(bool visited);
}