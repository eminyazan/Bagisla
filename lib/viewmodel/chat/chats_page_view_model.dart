import 'package:bagisla/model/message/speech.dart';
import 'package:bagisla/model/user/user_model.dart';
import 'package:bagisla/service/db/db_service.dart';
import 'package:bagisla/service/db/local_db_service.dart';
import 'package:bagisla/view/components/view_state.dart';
import 'package:get/state_manager.dart';

class ChatsPageViewModel {
  static final ChatsPageViewModel _chatsPageViewModel =
      ChatsPageViewModel._internal();

  factory ChatsPageViewModel() {
    return _chatsPageViewModel;
  }

  ChatsPageViewModel._internal();

  final Rx<ViewState> _viewState = ViewState.idle.obs;

  ViewState get getViewState => _viewState.value;

  set _setViewState(ViewState viewState) {
    _viewState(viewState);
  }

  final DBService _dbService = DBService();
  final LocalDBService _localDBService = LocalDBService();

  Future<List<Speech>?> getAllConversations() async {
    _setViewState = ViewState.busy;
    String userUid = _localDBService.readUserFromLocalDB()!.uid!;
    List<Speech>? conversations=await _dbService.getAllConversations(userUid);
    _setViewState = ViewState.idle;
    return conversations;
  }

  Stream<List<Speech>> getAllConversationsStream()  {
    _setViewState = ViewState.busy;
    String userUid = _localDBService.readUserFromLocalDB()!.uid!;
    Stream<List<Speech>> conversations= _dbService.getAllConversationsStream(userUid);
    _setViewState = ViewState.idle;
    return conversations;
  }

  Future<UserModel?> getUserFromDB() async {
    _setViewState = ViewState.busy;
    if (_localDBService.readUserFromLocalDB() != null) {
      String userUid = _localDBService.readUserFromLocalDB()!.uid!;
      UserModel? user = await _dbService.readUserFromDB(userUid);
      _setViewState = ViewState.idle;
      return user;
    } else {
      _setViewState = ViewState.idle;
      return null;
    }
  }
}
