import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static final StorageService _storageService = StorageService._internal();

  factory StorageService() {
    return _storageService;
  }

  StorageService._internal();

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  String? url;

  Future<String?> uploadPhoto(String userID, File image) async {
    Reference storageReference = _firebaseStorage
        .ref()
        .child("users")
        .child(userID)
        .child("profile_photo.png");
    UploadTask uploadTask = storageReference.putFile(
      image,
    );

    (await uploadTask.whenComplete(() async {
      url = await storageReference.getDownloadURL();
    }));
    return url;
  }

  Future<String?> uploadAdPhoto(String adId,String imageName, File image) async {
    Reference storageReference =
        _firebaseStorage.ref().child("ads").child(adId).child(imageName);
    UploadTask uploadTask = storageReference.putFile(
      image,
    );

    (await uploadTask.whenComplete(() async {
      url = await storageReference.getDownloadURL();
    }));
    return url;
  }
}
