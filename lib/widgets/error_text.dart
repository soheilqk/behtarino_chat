import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final String? text;
  const ErrorText(this.text);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 22,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text ?? ' ',
          maxLines: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.red,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
