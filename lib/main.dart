import 'package:behtarino_chat/constants/prefs.dart';
import 'package:behtarino_chat/screens/auth/auth_vm.dart';
import 'package:behtarino_chat/screens/auth/enter_phone_sc.dart';
import 'package:behtarino_chat/screens/auth/otp_sc.dart';
import 'package:behtarino_chat/screens/chat/chat_md.dart';
import 'package:behtarino_chat/screens/chat/chat_screen.dart';
import 'package:behtarino_chat/screens/chat/chat_vm.dart';
import 'package:behtarino_chat/screens/chat/contacts_sc.dart';
import 'package:behtarino_chat/utils/shared_prefs_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(HiveMessageAdapter());
  var loggedIn = await SharedPrefsUtils.getString(Prefs.token);
  runApp(MultiProvider(
    providers: [
      ListenableProvider(create: (context) => AuthViewModel()),
      ListenableProvider(create: (context) => ChatViewModel()),
    ],
    child: MaterialApp(
      title: 'Happy Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'IRANSans',
      ),
      home: loggedIn != null ? Contacts() : EnterPhoneScreen(),
      routes: {
        EnterPhoneScreen.routeName: (_) => EnterPhoneScreen(),
        OtpScreen.routeName: (_) => OtpScreen(),
        Contacts.routeName: (_) => Contacts(),
        ChatScreen.routeName: (_) => ChatScreen(),
      },
    ),
  ));
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
  ));
}
