import 'dart:math';

import 'package:behtarino_chat/constants/images.dart';
import 'package:behtarino_chat/screens/auth/auth_md.dart';
import 'package:hive/hive.dart';

part 'chat_md.g.dart';

class ContactListGR {
  Meta? meta;
  List<Contact>? data;

  ContactListGR({this.meta, this.data});

  factory ContactListGR.fromMap(Map<String, dynamic> json) => ContactListGR(
        meta: json["meta"] == null ? null : Meta.fromMap(json['meta']),
        data: json["data"] == null
            ? null
            : List<Contact>.from(json["data"].map((x) => Contact.fromMap(x))),
      );
}

class Contact {
  int? id;
  String? token;
  String? name;
  String? image;

  Contact({this.id, this.token, this.name,this.image});

  factory Contact.fromMap(Map<String, dynamic> json) => Contact(
        id: json["id"],
        token: json["token"],
        name: json["name"],
        image: Images.profiles[Random().nextInt(4)],
      );
}

class Message{
  String message;
  bool fromMe;
  int id;
  Message({required this.message,required this.fromMe,required this.id});
}

@HiveType(typeId: 0)
class HiveMessage extends HiveObject {

  @HiveField(0)
  int id;

  @HiveField(1)
  String text;

  @HiveField(3)
  bool fromMe;

  HiveMessage({required this.id,required this.text, required this.fromMe});

}
