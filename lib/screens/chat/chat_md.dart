import 'dart:math';

import 'package:behtarino_chat/constants/images.dart';
import 'package:behtarino_chat/screens/auth/auth_md.dart';

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
