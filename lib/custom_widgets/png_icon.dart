import 'package:flutter/material.dart';

class PngIcon extends StatelessWidget {
  final String fileName; // name of file inside "assets/icons/"  directory

  Color iconColor;
  final double size;

  PngIcon({
    @required this.fileName,
    this.size = 24,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    if (iconColor == null) iconColor = IconTheme.of(context).color;

    return Image.asset(
      'assets/icons/$fileName',
      color: iconColor,
      height: size,
      width: size,
      colorBlendMode: BlendMode.srcIn,
    );
  }
}