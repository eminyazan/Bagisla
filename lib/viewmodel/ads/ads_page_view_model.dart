import 'package:bagisla/model/ad/ad_model.dart';
import 'package:bagisla/service/db/db_service.dart';
import 'package:bagisla/view/components/view_state.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class AdsPageViewModel {
  static final AdsPageViewModel _adsPageViewModel =
      AdsPageViewModel._internal();

  factory AdsPageViewModel() {
    return _adsPageViewModel;
  }

  AdsPageViewModel._internal();

  final Rx<ViewState> _viewState = ViewState.idle.obs;

  ViewState get getViewState => _viewState.value;

  set _setViewState(ViewState viewState) {
    _viewState(viewState);
  }

  final DBService _dbService = DBService();

  Future<List<AdModel>?> getAllAds() async {
    _setViewState=ViewState.busy;
    List<AdModel>? adList = await _dbService.getAllAds();
    if (adList != null && adList.isNotEmpty) {
      _setViewState=ViewState.idle;
      return adList;
    }
    _setViewState=ViewState.idle;
    return null;
  }
}
