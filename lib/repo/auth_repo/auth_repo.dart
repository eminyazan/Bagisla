import 'dart:io';

import 'package:bagisla/model/user/user_model.dart';

import '../../bases/auth/auth_base.dart';
import '../../service/auth/auth_service.dart';

class AuthRepo extends AuthBase {
  final AuthService _authService = AuthService();
  UserModel? _user;

  @override
  Future<UserModel?> login(String email, String password) async {
    _user = await _authService.login(email, password);
    return _user;
  }

  @override
  Future<UserModel?> currentUser() async {
    _user = await _authService.currentUser();
    return _user;
  }

  @override
  Future<bool> logout() async {
    bool res = await _authService.logout();
    return res;
  }

  @override
  Future<UserModel?> register(String password, UserModel user,File? image) async {
    _user = await _authService.register(password, user,image);
    return _user;
  }

  @override
  Future<bool> sendPasswordResetMail(String email) async {
    bool res = await _authService.sendPasswordResetMail(email);
    return res;
  }


}
