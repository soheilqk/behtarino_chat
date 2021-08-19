import 'package:behtarino_chat/screens/auth/auth_md.dart';
import 'package:behtarino_chat/utils/httpClient.dart';
import 'package:behtarino_chat/utils/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class AuthRepository {
  late HttpClient hc;

  AuthRepository(BuildContext context){
    hc = HttpClient(context,logger: true);
  }


  Future<PhonePR> phoneVerification(BuildContext context, {PhonePD? pd}) async {
    try {
      Response response = await hc.post(Urls.phoneVerification,data: pd?.toMap());
      return PhonePR.fromMap(response.data);
    } on DioError catch (err){
      throw PhonePR.fromMap(err.response?.data);
    }
  }

  Future<PhonePR> tokenSign(BuildContext context, {PhonePD? pd}) async {
    try {
      Response response = await hc.post(Urls.tokenSign,data: pd?.toMap());
      return PhonePR.fromMap(response.data);
    } on DioError catch (err){
      throw PhonePR.fromMap(err.response?.data);
    }
  }

}