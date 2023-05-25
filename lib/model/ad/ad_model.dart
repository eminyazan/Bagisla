import 'package:cloud_firestore/cloud_firestore.dart';

class AdModel {
  String? uid;
  String? description;
  String iban;
  int amount;
  List<String>? images;
  String? ownerUid;
  String category;
  DateTime? date;
  bool payed;

  AdModel({
    this.uid,
    this.images,
    this.date,
    this.ownerUid,
    this.payed = false,
    this.description,
    required this.iban,
    required this.amount,
    required this.category,
  });

  AdModel.fromMap(Map<String, dynamic> map)
      : uid = map["uid"],
        description = map["description"],
        iban = map["iban"],
        amount = map["amount"],
        images = map['images'] != null ? (map['images']).toList().cast<String>() : null,
        ownerUid = map["ownerUid"],
        category = map["category"],
        payed = map["payed"],
        date = (map["date"] as Timestamp).toDate();

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'description': description??"Açıklama bulunmuyor",
      'iban': iban,
      'amount': amount,
      'images': images,
      'ownerUid': ownerUid,
      'category': category,
      'payed': payed,
      'date': date ?? FieldValue.serverTimestamp(),
    };
  }
}
