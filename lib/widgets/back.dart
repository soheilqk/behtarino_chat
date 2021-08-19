import 'package:behtarino_chat/constants/images.dart';
import 'package:flutter/material.dart';

class Back extends StatelessWidget {
  const Back({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('بازگشت',style: TextStyle(fontWeight: FontWeight.bold),),
        SizedBox(width: 4),
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            height: 30,
            width: 30,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color(0x1a243443),
            ),
            child: Image.asset(Images.backArrow,fit: BoxFit.fitWidth,),
          ),
        ),
      ],
    );
  }
}
