import 'package:behtarino_chat/screens/chat/chat_md.dart';
import 'package:behtarino_chat/utils/httpClient.dart';
import 'package:behtarino_chat/utils/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ChatRepository{
  late HttpClient hc;

  ChatRepository(BuildContext context){
    hc = HttpClient(context,logger: true);
  }

  Future<ContactListGR> getContactsList() async {
    try {
      Response response = await hc.get(Urls.contactsList);
      return ContactListGR.fromMap(response.data);
    } on DioError catch (err){
      throw ContactListGR.fromMap(err.response?.data);
    }
  }
}