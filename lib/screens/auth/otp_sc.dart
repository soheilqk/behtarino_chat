import 'package:behtarino_chat/screens/auth/auth_vm.dart';
import 'package:behtarino_chat/widgets/back.dart';
import 'package:behtarino_chat/widgets/backgroud.dart';
import 'package:behtarino_chat/widgets/error_text.dart';
import 'package:behtarino_chat/widgets/otp_pin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  static const routeName = 'otpScreen';

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late AuthViewModel authVM;
  var firstTime = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (firstTime) {
      authVM = context.watch<AuthViewModel>();
      authVM.firstPinCtr.addListener(() {
        if (authVM.firstPinCtr.text.length == 1) {
          authVM.secondPinFocus.requestFocus();
        }
      });
      authVM.secondPinCtr.addListener(() {
        if (authVM.secondPinCtr.text.length == 1) {
          authVM.thirdPinFocus.requestFocus();
        }
      });
      authVM.thirdPinCtr.addListener(() {
        if (authVM.thirdPinCtr.text.length == 1) {
          authVM.fourthPinFocus.requestFocus();
        }
      });
      authVM.fourthPinCtr.addListener(() {
        if (authVM.fourthPinCtr.text.length == 1) {
          authVM.fourthPinFocus.unfocus();
          if(!authVM.signInLoading)authVM.tokenSign(context);
        }
      });

      authVM.firstPinFocus.addListener(() {
        authVM.otpErrMsg = null;
      });
      authVM.secondPinFocus.addListener(() {
        authVM.otpErrMsg = null;
      });
      authVM.thirdPinFocus.addListener(() {
        authVM.otpErrMsg = null;
      });
      authVM.fourthPinFocus.addListener(() {
        authVM.otpErrMsg = null;
      });

      firstTime = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      resizeToAvoidBottomInset: false,
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Back(),
              ],
            ),
            SizedBox(height: 40),
            Text(
              'هپی چت',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'برای ثبت نام کد 4 رقمی ارسال شده را وارد نمایید.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
            ),
            SizedBox(height: 10),
            otp(),
            if (authVM.otpLoading) ...[
              SizedBox(height: 30),
              CircularProgressIndicator(
                  color: Color(0xffDA7E70), strokeWidth: 0.8)
            ] else ...[
              SizedBox(height: 10),
              ErrorText(authVM.otpErrMsg),
              SizedBox(height: 12),
              authVM.timer.isActive
                  ? Text(
                      'ارسال مجدد تا ${authVM.duration} ثانیه دیگر',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )
                  : TextButton(
                      onPressed: () => authVM.sendAgain(context),
                      child: Text(
                        'ارسال مجدد',
                        style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline),
                      )),
            ],
            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget otp() {
    return FocusScope(
      child: Row(
        children: [
          OtpPin(
            hasError: authVM.otpErrMsg != null,
            controller: authVM.firstPinCtr,
            focusNode: authVM.firstPinFocus,
          ),
          SizedBox(width: 15),
          OtpPin(
            hasError: authVM.otpErrMsg != null,
            controller: authVM.secondPinCtr,
            focusNode: authVM.secondPinFocus,
          ),
          SizedBox(width: 15),
          OtpPin(
            hasError: authVM.otpErrMsg != null,
            controller: authVM.thirdPinCtr,
            focusNode: authVM.thirdPinFocus,
          ),
          SizedBox(width: 15),
          OtpPin(
            hasError: authVM.otpErrMsg != null,
            controller: authVM.fourthPinCtr,
            focusNode: authVM.fourthPinFocus,
          ),
        ],
      ),
    );
  }
}
