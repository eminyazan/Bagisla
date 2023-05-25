import 'package:bagisla/model/message/message.dart';
import 'package:bagisla/model/user/user_model.dart';
import 'package:bagisla/service/db/db_service.dart';
import 'package:bagisla/service/db/local_db_service.dart';
import 'package:bagisla/view/components/view_state.dart';
import 'package:get/state_manager.dart';

class ChatPageViewModel {
  static final ChatPageViewModel _chatPageViewModel =
      ChatPageViewModel._internal();

  factory ChatPageViewModel() {
    return _chatPageViewModel;
  }

  ChatPageViewModel._internal();

  final DBService _dbService = DBService();
  final LocalDBService _localDBService = LocalDBService();

  final Rx<ViewState> _viewState = ViewState.idle.obs;

  ViewState get getViewState => _viewState.value;

  set _setViewState(ViewState viewState) {
    _viewState(viewState);
  }

  Future<UserModel?> getUser(String userId) async {
    _setViewState = ViewState.busy;
    UserModel? user = await _dbService.readUserFromDB(userId);
    _setViewState = ViewState.idle;
    return user;
  }

  Future<bool> saveMessage(Message saveMessage) async {
    return await _dbService.saveMessage(saveMessage);
  }

  Stream<List<Message>> bringOldMessages(String chattedUserID, String? lastMessage)  {
    return  _dbService.getMessageWithPagination(
      _localDBService.readUserFromLocalDB()!.uid!,
      chattedUserID,
      lastMessage,
    );
  }

  void updateSeen(String chattedUserUid)async {
    _dbService.updateSeen(chattedUserUid, _localDBService.readUserFromLocalDB()!.uid!,);
  }
}
