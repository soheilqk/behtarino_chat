import 'package:behtarino_chat/constants/images.dart';
import 'package:behtarino_chat/screens/chat/chat_vm.dart';
import 'package:behtarino_chat/widgets/backgroud.dart';
import 'package:behtarino_chat/widgets/contact_list_item.dart';
import 'package:behtarino_chat/widgets/header.dart';
import 'package:behtarino_chat/widgets/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Contacts extends StatefulWidget {
  static const routeName = 'contactsScreen';

  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  var firstTime = true;
  late final ChatViewModel chatVM;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (firstTime) {
      chatVM = context.watch<ChatViewModel>();
      chatVM.getContactsList(context, notify: false);
      firstTime = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Header(
            left: ProfileImage(Images.profile1, size: 45),
            right: IconButton(
              onPressed: () {},
              icon: Image.asset(
                Images.search,
                width: 16,
                height: 16,
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: chatVM.loading
                ? Center(
                    child: CircularProgressIndicator(
                        color: Color(0xffDA7E70), strokeWidth: 0.8),
                  )
                : ListView.builder(
                    itemCount: chatVM.contactsList.length,
                    itemBuilder: (context, index) => ContactListItem(
                      id: chatVM.contactsList[index].id!,
                      name: chatVM.contactsList[index].name!,
                      image: chatVM.contactsList[index].image!,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
