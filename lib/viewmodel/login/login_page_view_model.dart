
import 'package:bagisla/model/user/user_model.dart';
import 'package:bagisla/service/db/local_db_service.dart';
import 'package:get/get.dart';

import '../../repo/auth_repo/auth_repo.dart';
import '../../view/components/view_state.dart';


class LoginPageViewModel extends GetxController {
  static final LoginPageViewModel _loginPageViewModel =
  LoginPageViewModel._internal();

  factory LoginPageViewModel() {
    return _loginPageViewModel;
  }

  LoginPageViewModel._internal();

  final Rx<ViewState> _viewState = ViewState.idle.obs;

  ViewState get getViewState => _viewState.value;

  set setViewState(ViewState newViewState) {
    _viewState(newViewState);
  }

  final AuthRepo _authRepo = AuthRepo();

  final LocalDBService _localDBService=LocalDBService();

  Future<UserModel?> login(String email, String password) async {
    setViewState=ViewState.busy;
    UserModel? user = await _authRepo.login(email, password);
    if(user!=null){
      _localDBService.saveUserToLocalDB(user);
      setViewState=ViewState.idle;
      return user;
    }else{
      setViewState=ViewState.idle;
      return null;
    }
  }
}
