import 'package:uuid/uuid.dart';

var uuid = const Uuid();
String generateUid(){
  return uuid.v4();
}
