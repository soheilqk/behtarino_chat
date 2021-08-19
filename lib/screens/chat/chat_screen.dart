import 'package:behtarino_chat/constants/images.dart';
import 'package:behtarino_chat/screens/chat/chat_vm.dart';
import 'package:behtarino_chat/widgets/back.dart';
import 'package:behtarino_chat/widgets/backgroud.dart';
import 'package:behtarino_chat/widgets/header.dart';
import 'package:behtarino_chat/widgets/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  static const routeName = 'chatScreen';

  @override
  Widget build(BuildContext context) {
    final chatVM = context.watch<ChatViewModel>();
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
          Expanded(child: Container()),
          Container(
            height: 50,
            color: Color(0x59F6BEB1),
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      Images.send,
                      height: 30,
                      width: 30,
                    )),
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
