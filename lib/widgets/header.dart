import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final Widget? left;
  final Widget? center;
  final Widget? right;
  final EdgeInsets padding;

  Header({
    this.left,
    this.center,
    this.right,
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: left ?? Container(),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: center ?? Container(),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: right ?? Container(),
            ),
          ),
        ],
      ),
    );
  }
}
