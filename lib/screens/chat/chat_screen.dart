import 'package:behtarino_chat/constants/images.dart';
import 'package:behtarino_chat/constants/prefs.dart';
import 'package:behtarino_chat/screens/chat/chat_md.dart';
import 'package:behtarino_chat/screens/chat/chat_vm.dart';
import 'package:behtarino_chat/utils/mqtt.dart';
import 'package:behtarino_chat/utils/shared_prefs_utils.dart';
import 'package:behtarino_chat/widgets/back.dart';
import 'package:behtarino_chat/widgets/backgroud.dart';
import 'package:behtarino_chat/widgets/header.dart';
import 'package:behtarino_chat/widgets/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = 'chatScreen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var firstTime = true;
  var firstTimeMsg = true;
  late ChatViewModel chatVM;
  late String publishTopic;
  late String subscribeTopic;
  late MqttServerClient client;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (firstTime) {
      chatVM = context.watch<ChatViewModel>();
      if (firstTimeMsg) {
        await chatVM.getPastMessages();
        firstTimeMsg = false;
      }
      final optToken = await SharedPrefsUtils.getString(Prefs.token);
      publishTopic =
          'challenge/user/$optToken/${chatVM.selectedContact!.token}/';
      subscribeTopic =
          'challenge/user/${chatVM.selectedContact!.token}/$optToken/';
      client = await MQTT(context).connect(subscribeTopic);
      firstTime = false;
    }
  }

  @override
  void deactivate() {
    chatVM.setChatMessages([], notify: false);
    chatVM.selectedContact = null;
    client.disconnect();
    super.deactivate();
  }


  @override
  Widget build(BuildContext context) {
    return Background(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        children: [
          Header(
            left: ProfileImage(
              chatVM.selectedContact!.image!,
              size: 45,
            ),
            center: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                chatVM.selectedContact!.name!,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            right: Back(onPress: () => chatVM.selectedContact = null),
          ),
          Expanded(
            child:
            // chatVM.chatLoading
            //     ? Center(
            //         child: CircularProgressIndicator(
            //             color: Color(0xffDA7E70), strokeWidth: 0.8),
            //       )
            //     :
            chatVM.chatMessages.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            Images.portal,
                            height: MediaQuery.of(context).size.width * 0.4,
                            width: MediaQuery.of(context).size.width * 0.4,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              'هنوز به این دنیا وارد نشدی. یه پرتال بزن به گوشی رفیقت.\n',
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(8),
                        itemCount: chatVM.chatMessages.length,
                        itemBuilder: (context, index) {
                          var message = chatVM.chatMessages[index];
                          return GestureDetector(
                            onLongPress: () => chatVM.removeMessage(message),
                            child: Align(
                              alignment: message.fromMe
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                constraints: BoxConstraints(minHeight: 30),
                                margin: EdgeInsets.only(bottom: 8),
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                    color: message.fromMe
                                        ? Color(0xffFBDEAC)
                                        : Color(0xffF6BEB1),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(5),
                                      bottomRight: Radius.circular(5),
                                      topLeft:
                                          Radius.circular(message.fromMe ? 5 : 0),
                                      topRight:
                                          Radius.circular(message.fromMe ? 0 : 5),
                                    )),
                                child: Text(
                                  message.message,
                                  textAlign: message.fromMe
                                      ? TextAlign.right
                                      : TextAlign.left,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
          Container(
            height: 50,
            color: Color(0x59F6BEB1),
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    MQTT(context).publish(
                      message: chatVM.messageCtr.text,
                      client: client,
                      topic: publishTopic,
                      box: chatVM.selectedContact!.id.toString(),
                    );
                    chatVM.messageCtr.text = '';
                  },
                  icon: Image.asset(
                    Images.send,
                    height: 30,
                    width: 30,
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      controller: chatVM.messageCtr,
                      decoration: InputDecoration(
                          hintText: 'نوشتن پیام...', border: InputBorder.none),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
