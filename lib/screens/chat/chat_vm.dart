import 'package:behtarino_chat/constants/images.dart';
import 'package:behtarino_chat/screens/chat/chat_md.dart';
import 'package:behtarino_chat/screens/chat/chat_rp.dart';
import 'package:flutter/material.dart';

class ChatViewModel with ChangeNotifier {

  bool _loading = true;
  bool get loading => _loading;
  setLoading(bool value,{bool notify = true}){
    _loading = value;
    if(notify) notifyListeners();
  }

  List<Contact> _contactsList = [];
  List<Contact> get contactsList => _contactsList;
  setContactsList(List<Contact> list,{bool notify = true}){
    _contactsList = list;
    if(notify) notifyListeners();
  }

  Contact? selectedContact;

  final messageCtr = TextEditingController();

  getContactsList(BuildContext context,{bool notify = true}) async {
    try{
      setLoading(true,notify: notify);
      final res = await ChatRepository(context).getContactsList();
      if(res.meta?.statusCode == 200){
        setContactsList(res.data ?? [],notify: notify);
      }
    } on ContactListGR catch (_) {

    } finally{
      setLoading(false);
    }
  }

}