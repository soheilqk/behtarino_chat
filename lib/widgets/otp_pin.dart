import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpPin extends StatelessWidget {
  FocusNode focusNode;
  TextEditingController controller;
  final bool hasError;

  OtpPin({required this.focusNode, required this.controller,this.hasError = false,});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: hasError ? Colors.red : focusNode.hasFocus ? Colors.black : Colors.grey[300]!),
          borderRadius: BorderRadius.circular(5),
        ),
        child: TextFormField(
         // autofocus: focusNode.hasFocus,
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(border: InputBorder.none),
          inputFormatters: [LengthLimitingTextInputFormatter(1)],
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
