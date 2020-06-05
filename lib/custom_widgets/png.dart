import 'package:flutter/material.dart';
import 'package:keep_notes_clone/utils/colors.dart';

// I created this for grabbing icons from google icons cuz not all of them
// are available from material icons provided with flutter i.e., "Icons.foo"
class PngIcon extends StatelessWidget {
  final String fileName; // name of file inside "assets/icons/"  directory

  final Color iconColor;
  final double size;

  PngIcon({
    @required this.fileName,
    this.size = 24,
    this.iconColor = appIconGrey,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icons/$fileName',
      color: iconColor,
      height: size,
      width: size,
      colorBlendMode: BlendMode.srcIn,
    );
  }
}

class PngIconButton extends StatelessWidget {
  final PngIcon pngIcon;

  final void Function() onTap;

  PngIconButton({@required this.pngIcon, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: pngIcon);
  }
}
