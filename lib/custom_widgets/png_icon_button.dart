import 'package:flutter/material.dart';
import 'package:keep_notes_clone/custom_widgets/png_icon.dart';

class PngIconButton extends StatelessWidget {
  final PngIcon pngIcon;

  final void Function() onTap;

  PngIconButton({@required this.pngIcon, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: pngIcon);
  }
}
