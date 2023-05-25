import 'package:bagisla/model/ad/ad_model.dart';
import 'package:bagisla/service/db/db_service.dart';
import 'package:bagisla/view/components/view_state.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class SearchPageViewModel {
  static final SearchPageViewModel _searchPageViewModel =
      SearchPageViewModel._internal();

  factory SearchPageViewModel() {
    return _searchPageViewModel;
  }

  SearchPageViewModel._internal();

  final Rx<ViewState> _viewState = ViewState.idle.obs;

  ViewState get getViewState => _viewState.value;
  

  final DBService _dbService = DBService();

  Future<List<AdModel>?> search(String text) async {
    return await _dbService.search(text);
  }
}
