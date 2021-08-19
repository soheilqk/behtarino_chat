import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final String path;
  final double size;

  ProfileImage(this.path, {this.size = 60});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: CircleAvatar(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.asset(path),
        ),
      ),
    );
  }
}
