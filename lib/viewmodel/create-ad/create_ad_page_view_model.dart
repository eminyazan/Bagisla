import 'dart:io';

import 'package:bagisla/model/ad/ad_model.dart';
import 'package:bagisla/service/db/db_service.dart';
import 'package:bagisla/service/db/local_db_service.dart';
import 'package:bagisla/service/storage/storage_service.dart';
import 'package:bagisla/util/uid_generator.dart';
import 'package:get/get.dart';

import '../../view/components/view_state.dart';

class CreateAdPageViewModel extends GetxController {
  static final CreateAdPageViewModel _createAdPageViewModel =
      CreateAdPageViewModel._internal();

  factory CreateAdPageViewModel() {
    return _createAdPageViewModel;
  }

  CreateAdPageViewModel._internal();

  final Rx<ViewState> _viewState = ViewState.idle.obs;

  ViewState get getViewState => _viewState.value;

  set _setViewState(ViewState newViewState) {
    _viewState(newViewState);
  }

  final LocalDBService _localDBService = LocalDBService();
  final StorageService _storageService = StorageService();
  final DBService _dbService = DBService();

  Future<bool?> saveAdToDB(AdModel ad, List<File> adImages) async {
    _setViewState = ViewState.busy;
    List<String> urls = [];
    if (_localDBService.readUserFromLocalDB() != null) {
      String userUid = _localDBService.readUserFromLocalDB()!.uid!;
      ad.ownerUid = userUid;
      ad.uid = generateUid();

      for (int i = 0; i < adImages.length; i++) {
        String? url = await _storageService.uploadAdPhoto(
            ad.uid!, "${ad.uid}_$i", adImages[i]);
        url != null ? urls.add(url) : null;
      }
      urls.isEmpty ? null : ad.images = urls;

      bool res = await _dbService.saveAdToDB(
        ad,
        userUid
      );
      _setViewState = ViewState.idle;
      return res;
    } else {
      _setViewState = ViewState.idle;
      return null;
    }
  }
}
