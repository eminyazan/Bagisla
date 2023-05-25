import 'dart:io';

import 'package:bagisla/model/user/user_model.dart';
import 'package:bagisla/repo/auth_repo/auth_repo.dart';
import 'package:bagisla/service/db/db_service.dart';
import 'package:bagisla/service/db/local_db_service.dart';
import 'package:bagisla/service/storage/storage_service.dart';
import 'package:bagisla/view/components/view_state.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class SettingsPageViewModel {
  static final SettingsPageViewModel _settingsPageViewModel = SettingsPageViewModel._internal();

  factory SettingsPageViewModel() {
    return _settingsPageViewModel;
  }

  SettingsPageViewModel._internal();

  final Rx<ViewState> _viewState = ViewState.idle.obs;

  ViewState get getViewState => _viewState.value;

  set _setViewState(ViewState newViewState) {
    _viewState(newViewState);
  }

  final DBService _dbService = DBService();
  final LocalDBService _localDBService = LocalDBService();
  final AuthRepo _authRepo = AuthRepo();
  final StorageService _storageService = StorageService();

  Future<UserModel?> getUserInfo() async {
    _setViewState = ViewState.busy;
    UserModel? user = _localDBService.readUserFromLocalDB();
    if (user != null) {
      user = await _dbService.readUserFromDB(user.uid!);
      _setViewState = ViewState.idle;
      return user;
    } else {
      _setViewState = ViewState.idle;
      return null;
    }
  }

  Future<void> logout() async {
    _setViewState = ViewState.busy;
    bool res = await _authRepo.logout();
    _setViewState = ViewState.idle;
    res ? _localDBService.removeFromLocalDB() : null;
  }

  Future<bool> sendPasswordResetMail(String email) async {
    _setViewState = ViewState.busy;
    bool res = await _authRepo.sendPasswordResetMail(email);
    _setViewState = ViewState.idle;
    return res;
  }

  Future<bool>updateProfilePhoto(File image) async {
    _setViewState = ViewState.busy;
    String? userUid = _localDBService.readUserFromLocalDB()?.uid;

    String? url = await _storageService.uploadPhoto(userUid!, image);

    await _dbService.updateUserField(userUid, "photoUrl", url!);
    _setViewState = ViewState.idle;
    return true;
  }
}
