class PhonePD {
  String? phone;
  String? username;
  String? password;

  PhonePD({this.phone, this.username, this.password});

  Map<String, dynamic> toMap() => {
        'phone': phone,
        'username': username,
        'password': password,
      };
}

class PhonePR {
  Meta? meta;
  Data? data;

  PhonePR({this.meta, this.data});

  factory PhonePR.fromMap(Map<String, dynamic> json) => PhonePR(
        meta: json["meta"] == null ? null : Meta.fromMap(json["meta"]),
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
      );
}

class Meta {
  int? statusCode;
  Detail? detail;
  bool? paginated;

  Meta({this.statusCode, this.detail, this.paginated});

  factory Meta.fromMap(Map<String, dynamic> json) => Meta(
        statusCode: json['status_code'],
        detail: json["detail"] == null ? null : Detail.fromMap(json["detail"]),
        paginated: json['paginated'],
      );
}

class Data {
  bool? ok;
  String? expiry;
  String? token;
  User? user;

  Data({this.ok, this.expiry, this.token, this.user});

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        ok: json['ok'],
        expiry: json['expiry'],
        token: json['token'],
        user: json['user'] == null ? null : User.fromMap(json['user']),
      );
}

class User {
  String? username;

  User({this.username});

  factory User.fromMap(Map<String, dynamic> json) => User(
        username: json['username'],
      );
}

class Detail {
  List<String>? globalErrorMessages;
  String? phone;
  List<String>? nonFieldErrors;

  Detail({this.globalErrorMessages, this.phone, this.nonFieldErrors});

  factory Detail.fromMap(Map<String, dynamic> json) => Detail(
        globalErrorMessages: json["global_error_messages"] == null
            ? null
            : List<String>.from(json["global_error_messages"].map((x) => x)),
        nonFieldErrors: json["non_field_errors"] == null
            ? null
            : List<String>.from(json["non_field_errors"].map((x) => x)),
        phone: json['phone'],
      );
}
