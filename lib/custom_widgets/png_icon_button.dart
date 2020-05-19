import 'package:flutter/material.dart';

class PngIconButton extends StatelessWidget {
  final String fileName; // name of file inside "assets/icons/"  directory

  Color iconColor;
  final void Function() onTap;
  final double size;

  PngIconButton(
      {@required this.fileName,
      this.size = 24,
      this.iconColor,
      @required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (iconColor == null) iconColor = IconTheme.of(context).color;

    return GestureDetector(
        onTap: onTap,
        child: Image.asset(
          'assets/icons/$fileName',
          color: iconColor,
          height: size,
          width: size,
          colorBlendMode: BlendMode.srcIn,
        ));
  }
}
