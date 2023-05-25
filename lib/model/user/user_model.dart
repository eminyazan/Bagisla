import 'package:bagisla/consts/consts.dart';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  String? uid;
  @HiveField(1)
  String name;
  @HiveField(2)
  String surname;
  @HiveField(3)
  String email;
  @HiveField(4)
  String? photoUrl;

  List<String>? ads;
  List<String>? chats;

  UserModel({
    this.uid,
    required this.name,
    required this.surname,
    required this.email,
    this.photoUrl,
    this.ads,
    this.chats,
  });

  UserModel.fromMap(Map<String, dynamic> map)
      : uid = map["uid"],
        name = map["name"],
        surname = map["surname"],
        email = map["email"],
        ads = map['ads']!=null?(map['ads']).toList().cast<String>():null,
        chats = map['chats']!=null?(map['chats']).toList().cast<String>():null,
        photoUrl = map["photoUrl"];

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'surname': surname,
      'email': email,
      'ads': ads,
      'chats': chats,
      'photoUrl': photoUrl ?? DEFAULT_PP,
    };
  }
}
