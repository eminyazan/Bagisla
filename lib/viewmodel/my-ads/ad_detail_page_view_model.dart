
import 'package:bagisla/model/user/user_model.dart';
import 'package:bagisla/service/db/db_service.dart';
import 'package:get/get.dart';

import '../../view/components/view_state.dart';

class AdDetailPageViewModel extends GetxController {
  static final AdDetailPageViewModel _adDetailPageViewModel =
  AdDetailPageViewModel._internal();

  factory AdDetailPageViewModel() {
    return _adDetailPageViewModel;
  }

  AdDetailPageViewModel._internal();

  final Rx<ViewState> _viewState = ViewState.idle.obs;

  ViewState get getViewState => _viewState.value;

  set _setViewState(ViewState newViewState) {
    _viewState(newViewState);
  }

  final DBService _dbService = DBService();

  Future<UserModel?> getUserInfo(String uid) async {
    _setViewState = ViewState.busy;
    UserModel? user=await _dbService.readUserFromDB(uid);
    _setViewState = ViewState.idle;
    return user;
  }
  Future<bool>updatePaymentStatus(String adId)async{
    _setViewState = ViewState.busy;
    bool res=await _dbService.updatePaymentStatus(adId);
    _setViewState = ViewState.idle;
    return res;
  }
}
