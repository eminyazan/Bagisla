import 'dart:io';

import 'package:bagisla/consts/consts.dart';
import 'package:bagisla/model/user/user_model.dart';
import 'package:bagisla/repo/auth_repo/auth_repo.dart';
import 'package:bagisla/view/components/view_state.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class RegisterPageViewModel extends GetxController {

  static final RegisterPageViewModel _registerPageViewModel = RegisterPageViewModel._internal();

  factory RegisterPageViewModel() {
    return _registerPageViewModel;
  }

  RegisterPageViewModel._internal();

  final Rx<ViewState> _viewState = ViewState.idle.obs;

  ViewState get getViewState => _viewState.value;

  set setViewState(ViewState newViewState) {
    _viewState(newViewState);
  }

  final AuthRepo _authRepo = AuthRepo();

  final Box<UserModel> _dealerBox = Hive.box<UserModel>(LOCAL_DB_BOX);

  Future<UserModel?> register(String password,UserModel user,File? image) async {
    setViewState=ViewState.busy;
    UserModel? resUser = await _authRepo.register(password,user,image);
    if(resUser!=null){
      _dealerBox.put(LOCAL_DB_BOX, resUser);
      setViewState=ViewState.idle;
      return resUser;
    }else{
      setViewState=ViewState.idle;
      return null;
    }
  }

}
