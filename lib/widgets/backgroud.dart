import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final EdgeInsets padding;
  final bool resizeToAvoidBottomInset;

  Background({
    required this.child,
    this.gradient = const RadialGradient(
      colors: [Color(0xffFCEDEA), Colors.white],
      radius: 1,
      focal: Alignment.bottomCenter,
    ),
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.resizeToAvoidBottomInset = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: padding,
          decoration: BoxDecoration(gradient: gradient),
          child: child,
        ),
      ),
    );
  }
}
