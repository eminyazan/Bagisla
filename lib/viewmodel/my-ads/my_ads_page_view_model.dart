
import 'package:bagisla/model/ad/ad_model.dart';
import 'package:bagisla/service/db/db_service.dart';
import 'package:bagisla/service/db/local_db_service.dart';
import 'package:get/get.dart';

import '../../view/components/view_state.dart';

class MyAdsPageViewModel extends GetxController {
  static final MyAdsPageViewModel _myAdsPageViewModel =
      MyAdsPageViewModel._internal();

  factory MyAdsPageViewModel() {
    return _myAdsPageViewModel;
  }

  MyAdsPageViewModel._internal();

  final Rx<ViewState> _viewState = ViewState.idle.obs;

  ViewState get getViewState => _viewState.value;

  set _setViewState(ViewState newViewState) {
    _viewState(newViewState);
  }

  final LocalDBService _localDBService = LocalDBService();
  final DBService _dbService = DBService();

  Future<List<AdModel>?> getAdsFromDB() async {
    _setViewState = ViewState.busy;
    if (_localDBService.readUserFromLocalDB() != null) {
      String userUid = _localDBService.readUserFromLocalDB()!.uid!;
      List<AdModel>? ads=await _dbService.getUserAdsFromDB(userUid);
      _setViewState = ViewState.idle;
      return ads;
    } else {
      _setViewState = ViewState.idle;
      return null;
    }
  }
}
