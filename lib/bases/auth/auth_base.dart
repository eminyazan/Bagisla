
import 'dart:io';

import 'package:bagisla/model/user/user_model.dart';



abstract class AuthBase{
  Future<UserModel?>login(String email,String password);
  Future<UserModel?>register(String password,UserModel user,File? image);
  Future<UserModel?>currentUser();
  Future<bool>logout();
  Future<bool>sendPasswordResetMail(String email);
}