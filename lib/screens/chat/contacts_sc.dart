import 'package:behtarino_chat/widgets/backgroud.dart';
import 'package:flutter/material.dart';

class Contacts extends StatelessWidget {
  static const routeName = 'contactsScreen';

  @override
  Widget build(BuildContext context) {
    return Background(child: Container(child: Text('Contacts'),));
  }
}
