import 'dart:async';

import 'package:behtarino_chat/constants/prefs.dart';
import 'package:behtarino_chat/screens/auth/auth_md.dart';
import 'package:behtarino_chat/screens/auth/auth_rp.dart';
import 'package:behtarino_chat/screens/auth/otp_sc.dart';
import 'package:behtarino_chat/screens/chat/contacts_sc.dart';
import 'package:behtarino_chat/utils/shared_prefs_utils.dart';
import 'package:flutter/material.dart';

class AuthViewModel with ChangeNotifier {
  //
  bool loggedIn = false;

  final phoneCtr = TextEditingController();
  final firstPinCtr = TextEditingController();
  final secondPinCtr = TextEditingController();
  final thirdPinCtr = TextEditingController();
  final fourthPinCtr = TextEditingController();

  final phoneFocus = FocusNode();
  final firstPinFocus = FocusNode();
  final secondPinFocus = FocusNode();
  final thirdPinFocus = FocusNode();
  final fourthPinFocus = FocusNode();

  String get phone => phoneCtr.text.replaceAll(' ', '');

  String get otp =>
      firstPinCtr.text +
      secondPinCtr.text +
      thirdPinCtr.text +
      fourthPinCtr.text;

  late Timer timer;
  int _duration = 40;
  int get duration => _duration;
  set duration(int value){
    _duration = value;
    notifyListeners();
  }

  startTimer(){
    duration = 40;
  timer = Timer.periodic(Duration(seconds: 1), (timer) {
    if(duration == 0){
      timer.cancel();
      notifyListeners();
    } else{
      duration -= 1;
    }
  });
  }

  bool _signInLoading = false;
  bool get signInLoading => _signInLoading;
  set signInLoading(bool value) {
    _signInLoading = value;
    notifyListeners();
  }

  bool _otpLoading = false;
  bool get otpLoading => _otpLoading;
  set otpLoading(bool value) {
    _otpLoading = value;
    notifyListeners();
  }

  bool _signInDisabled = true;
  bool get signInDisabled => _signInDisabled;
  set signInDisabled(bool value) {
    _signInDisabled = value;
    notifyListeners();
  }

  String? _phoneErrMsg;
  String? get phoneErrMsg => _phoneErrMsg;
  set phoneErrMsg(String? value) {
    _phoneErrMsg = value;
    notifyListeners();
  }

  String? _otpErrMsg;
  String? get otpErrMsg => _otpErrMsg;
  set otpErrMsg(String? value) {
    _otpErrMsg = value;
    notifyListeners();
  }

  signIn(BuildContext context) async {
    phoneFocus.unfocus();
    try {
      signInLoading = true;
      final res = await AuthRepository(context).phoneVerification(
        pd: PhonePD(phone: phone),
      );
      if (res.meta?.statusCode == 200) {
        startTimer();
        Navigator.of(context).pushNamed(OtpScreen.routeName);
      }
    } on PhonePR catch (_) {} finally {
      signInLoading = false;
    }
  }

  sendAgain(BuildContext context) async {
    try {
      firstPinCtr.text =  '';
      secondPinCtr.text =  '';
      thirdPinCtr.text =  '';
      fourthPinCtr.text =  '';
      otpLoading = true;
      otpErrMsg = null;
      final res = await AuthRepository(context).phoneVerification(
        pd: PhonePD(phone: phone),
      );
      if (res.meta?.statusCode == 200) {
        startTimer();
      }
    } on PhonePR catch (_) {} finally {
      otpLoading = false;
    }
  }

  tokenSign(BuildContext context) async {
    try {
      otpLoading = true;
      final res = await AuthRepository(context).tokenSign(
        pd: PhonePD(username: phone, password: otp),
      );
      if (res.meta?.statusCode == 200) {
        SharedPrefsUtils.addString(Prefs.expiry, res.data!.expiry!);
        SharedPrefsUtils.addString(Prefs.token, res.data!.token!);
        SharedPrefsUtils.addString(Prefs.username, res.data!.user!.username!);
        Navigator.of(context).pushNamedAndRemoveUntil(
            Contacts.routeName,(Route<dynamic> route) => false);
      }
      if(res.meta?.statusCode == 400 && res.meta?.detail?.nonFieldErrors != null){
        otpErrMsg = res.meta?.detail?.nonFieldErrors?.first;
      }
    } on PhonePR catch (err) {
      if(err.meta?.detail?.nonFieldErrors != null){
        otpErrMsg = err.meta?.detail?.nonFieldErrors?.first;
      }
    } finally {
      otpLoading = false;
    }
  }

  notify() => notifyListeners();
}
