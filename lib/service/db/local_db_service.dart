import 'package:bagisla/bases/db/local_db_base.dart';
import 'package:bagisla/consts/consts.dart';
import 'package:bagisla/model/user/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';


class LocalDBService extends LocalDBBase {
  static final LocalDBService _localDBService = LocalDBService._internal();

  factory LocalDBService() {
    return _localDBService;
  }

  LocalDBService._internal();

  final Box<UserModel> _userBox = Hive.box<UserModel>(LOCAL_DB_BOX);
  final Box<bool> _onboardBox = Hive.box<bool>(ONBOARD_BOX);



  @override
  Future<bool> saveUserToLocalDB(UserModel user) async {
    await _userBox.put(LOCAL_DB_BOX, user);
    return true;
  }

  @override
  Future<Box<bool>> openBoxForOnBoard() async {
    Box<bool> onBoardBox = await Hive.openBox<bool>(ONBOARD_BOX);
    return onBoardBox;
  }

  @override
  Future<Box<UserModel>> openBoxForUser() async {
    Box<UserModel> localUser = await Hive.openBox<UserModel>(LOCAL_DB_BOX);
    return localUser;
  }

  @override
  Future<void> saveOnBoardPageVisited(bool visited) async {
    await _onboardBox.put(
      ONBOARD_BOX,
      true,
    );
  }

  @override
  Future<void> initializeDB() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserModelAdapter());
  }

  @override
  UserModel? readUserFromLocalDB() {
    return _userBox.get(LOCAL_DB_BOX);
  }

  @override
  bool readOnBoardFromLocalDB() {
    return _onboardBox.isEmpty;
  }

  @override
  Future<bool> removeFromLocalDB() async{
    await _userBox.clear();
    return true;
  }
}
