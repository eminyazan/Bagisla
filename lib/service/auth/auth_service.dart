import 'dart:io';

import 'package:bagisla/model/user/user_model.dart';
import 'package:bagisla/service/storage/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../bases/auth/auth_base.dart';
import '../../service/db/db_service.dart';

class AuthService extends AuthBase {
  static final AuthService _authService = AuthService._internal();

  factory AuthService() {
    return _authService;
  }

  AuthService._internal();

  final _firebaseAuthService = FirebaseAuth.instance;
  final DBService _dbService = DBService();
  final StorageService _storageService = StorageService();

  @override
  Future<UserModel?> login(String email, String password) async {
    UserCredential credential = await _firebaseAuthService
        .signInWithEmailAndPassword(email: email, password: password);

    return credential.user != null ? _userFromFirebase(credential.user!) : null;
  }

  @override
  Future<UserModel?> register(
      String password, UserModel user, File? image) async {
    String? url;

    UserCredential credential = await _firebaseAuthService
        .createUserWithEmailAndPassword(email: user.email, password: password);

    user.uid = credential.user!.uid;

    image != null
        ? url = await _storageService.uploadPhoto(user.uid!, image)
        : null;
    user.photoUrl = url;

    bool res = await _dbService.saveUserToDB(user);

    return res
        ? credential.user != null
            ? _userFromFirebase(credential.user!)
            : null
        : null;
  }

  @override
  Future<UserModel?> currentUser() async {
    return _firebaseAuthService.currentUser != null
        ? _userFromFirebase(_firebaseAuthService.currentUser!)
        : null;
  }

  @override
  Future<bool> logout() async {
    await _firebaseAuthService.signOut();
    return true;
  }

  Future<UserModel?> _userFromFirebase(User user) async {
    return await _dbService.readUserFromDB(user.uid);
  }

  @override
  Future<bool> sendPasswordResetMail(String email) async {
    await _firebaseAuthService.sendPasswordResetEmail(email: email);
    return true;
  }
}
