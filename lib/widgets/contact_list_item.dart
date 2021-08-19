import 'package:behtarino_chat/screens/chat/chat_screen.dart';
import 'package:behtarino_chat/screens/chat/chat_vm.dart';
import 'package:behtarino_chat/widgets/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactListItem extends StatelessWidget {
  final int id;
  final String name;
  final String image;

  ContactListItem({required this.id, required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    final chatVM = context.watch<ChatViewModel>();
    return Column(
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: SizedBox(
            height: 65,
            child: ListTile(
              onTap: () {
                chatVM.selectedContact = chatVM.contactsList
                    .firstWhere((element) => element.id == id);
                Navigator.of(context).pushNamed(ChatScreen.routeName);
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 5),
              leading: ProfileImage(image),
              title: Text(name),
              subtitle: Text('سلام چطوری؟!'),
              trailing: Column(
                children: [
                  Text(
                    '2 ساعت پیش',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
