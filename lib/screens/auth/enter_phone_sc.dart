import 'package:behtarino_chat/constants/images.dart';
import 'package:behtarino_chat/screens/auth/auth_vm.dart';
import 'package:behtarino_chat/utils/validation.dart';
import 'package:behtarino_chat/widgets/backgroud.dart';
import 'package:behtarino_chat/widgets/error_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EnterPhoneScreen extends StatefulWidget {
  static const routeName = 'enterPhoneScreen';
  const EnterPhoneScreen({Key? key}) : super(key: key);

  @override
  _EnterPhoneScreenState createState() => _EnterPhoneScreenState();
}

class _EnterPhoneScreenState extends State<EnterPhoneScreen> {
  late AuthViewModel authVM;
  var firstTime = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (firstTime) {
      authVM = context.watch<AuthViewModel>();
      authVM.phoneCtr.addListener(() {
        authVM.signInDisabled = authVM.phone.length == 11 ? false : true;
      });
      firstTime = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: [
              Spacer(),
              Text(
                'هپی چت',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'برای ثبت نام شماره تلفن خود را وارد نمایید.',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
              ),
              SizedBox(height: 10),
              phoneField(),
              Spacer(flex: 2),
              signInButton(),
              Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget phoneField() {
    return Column(
      children: [
        Opacity(
          opacity: authVM.signInLoading ? 0.4 : 1,
          child: Container(
            height: 65,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color:
                    authVM.phoneErrMsg == null ? Colors.grey[300]! : Colors.red,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    Images.iranFlag,
                    fit: BoxFit.fitWidth,
                    width: 40,
                  ),
                ),
                VerticalDivider(
                    color: Colors.grey[400], indent: 5, endIndent: 5),
                Expanded(
                  child: TextFormField(
                    focusNode: authVM.phoneFocus,
                    controller: authVM.phoneCtr,
                    readOnly: authVM.signInLoading,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'شماره تلفن خود را وارد نمایید',
                      hintStyle: TextStyle(color: Colors.grey[300]),
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [PhoneFormatter()],
                    onFieldSubmitted:
                        authVM.signInDisabled || authVM.signInLoading
                            ? null
                            : (_) => authVM.signIn(context),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 15),
        ErrorText(authVM.phoneErrMsg),
      ],
    );
  }

  Widget signInButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          )),
          backgroundColor: MaterialStateProperty.all(
              authVM.signInDisabled ? Color(0xffC3C7CB) : Colors.black),
        ),
        child: authVM.signInLoading
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : Text(
                'ثبت نام',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
        onPressed: authVM.signInDisabled || authVM.signInLoading
            ? null
            : () => authVM.signIn(context),
      ),
    );
  }
}
