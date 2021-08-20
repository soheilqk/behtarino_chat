import 'package:behtarino_chat/constants/images.dart';
import 'package:behtarino_chat/screens/chat/chat_md.dart';
import 'package:behtarino_chat/screens/chat/chat_rp.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ChatViewModel with ChangeNotifier {

  bool _loading = true;
  bool get loading => _loading;
  setLoading(bool value,{bool notify = true}){
    _loading = value;
    if(notify) {
      notifyListeners();
    }
  }
  bool _chatLoading = true;
  bool get chatLoading => _chatLoading;
  setChatLoading(bool value,{bool notify = true}){
    _chatLoading = value;
    if(notify) {
      notifyListeners();
    }
  }

  List<Contact> _contactsList = [];
  List<Contact> get contactsList => _contactsList;
  setContactsList(List<Contact> list,{bool notify = true}){
    _contactsList = list;
    if(notify) notifyListeners();
  }

  List<Message> _chatMessages = [];
  List<Message> get chatMessages => _chatMessages;
  setChatMessages(List<Message> list,{bool notify = true}){
    _chatMessages = list;
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

  getPastMessages() async {
    setChatLoading(true,notify: false);
     var box = await Hive.openBox(selectedContact!.id.toString());
     if(box.get('messages') != null){
       List<dynamic> messages = box.get('messages');
       messages.forEach((e) {
         chatMessages
             .add(Message(id: e.id, message: e.text, fromMe: e.fromMe));
       });
       setChatLoading(false);
       notifyListeners();
     }
  }

  addToHive(Message msg) async {
    var box = await Hive.openBox(selectedContact!.id.toString());
    if(box.get('messages') == null){
      box.put('messages', []);
    }
    box.get('messages').add(HiveMessage(id: msg.id, text: msg.message, fromMe: msg.fromMe));
  }

  removeMessage(Message message)  async {
    chatMessages.removeWhere((e) => e.id == message.id);
    var box = await Hive.openBox(selectedContact!.id.toString());
    box.get('messages').removeWhere((e) => e.id == message.id);
    notifyListeners();
  }

  notify(){
    notifyListeners();
  }

}