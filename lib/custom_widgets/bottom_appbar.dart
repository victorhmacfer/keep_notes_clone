import 'package:flutter/material.dart';
import 'package:keep_notes_clone/custom_widgets/png_icon.dart';

import 'package:keep_notes_clone/custom_widgets/png_icon_button.dart';

import 'package:keep_notes_clone/colors.dart';
import 'package:keep_notes_clone/styles.dart';

class MyBottomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return BottomAppBar(
      color: appTranslucentWhite,
      notchMargin: 6,
      shape: CircularNotchedRectangle(),
      child: Container(
        height: 48,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 16),
        child: SizedBox(
          width: screenWidth * 0.4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              PngIconButton(
                  pngIcon: PngIcon(
                    fileName: 'outline_check_box_black_48.png',
                  ),
                  onTap: () {}),
              PngIconButton(
                  pngIcon: PngIcon(
                    fileName: 'outline_brush_black_48.png',
                  ),
                  onTap: () {}),
              PngIconButton(
                  pngIcon: PngIcon(
                    fileName: 'outline_mic_none_black_48.png',
                  ),
                  onTap: () {}),
              PngIconButton(
                  pngIcon: PngIcon(
                    fileName: 'outline_photo_black_48.png',
                  ),
                  onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}

class MyStickyBottomAppBar extends StatelessWidget {
  Widget _bottomSheetTile(PngIcon pngIcon, String text) {
    return Container(
      alignment: Alignment.centerLeft,
      height: 48,
      width: double.infinity,
      padding: EdgeInsets.only(left: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          pngIcon,
          SizedBox(
            width: 24,
          ),
          Text(text, style: bottomSheetStyle)
        ],
      ),
    );
  }

  Widget _leftBottomSheetBuilder(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _bottomSheetTile(
              PngIcon(
                fileName: 'outline_photo_camera_black_48.png',
              ),
              'Take photo'),
          _bottomSheetTile(
              PngIcon(
                fileName: 'outline_photo_black_48.png',
              ),
              'Add image'),
          _bottomSheetTile(
              PngIcon(
                fileName: 'outline_brush_black_48.png',
              ),
              'Drawing'),
          _bottomSheetTile(
              PngIcon(
                fileName: 'outline_mic_none_black_48.png',
              ),
              'Recording'),
          _bottomSheetTile(
              PngIcon(
                fileName: 'outline_check_box_black_48.png',
              ),
              'Checkboxes'),
        ],
      ),
    );
  }



  Widget _colorSelectionCircle(CardColor cardColor) {

    return Container(
      decoration: BoxDecoration(
        color: cardColor.getColor(),
        border: Border.all(width: 0.5, color: Colors.grey[400]),
        borderRadius: BorderRadius.circular(20)
      ),
      width: 32,
      margin: EdgeInsets.symmetric(horizontal: 7),
      child: Visibility(
        visible: false,
        child: Icon(Icons.check)
      ),

    );

  }



  Widget _colorSelectionList() {
    return Container(
      color: appWhite,
      height: 52,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,

        children: <Widget>[
          SizedBox(width: 8,),
          _colorSelectionCircle(CardColor.white),
          _colorSelectionCircle(CardColor.red),
          _colorSelectionCircle(CardColor.orange),
          _colorSelectionCircle(CardColor.yellow),
          _colorSelectionCircle(CardColor.green),
          _colorSelectionCircle(CardColor.lightBlue),
          _colorSelectionCircle(CardColor.mediumBlue),
          _colorSelectionCircle(CardColor.darkBlue),
          _colorSelectionCircle(CardColor.purple),
          _colorSelectionCircle(CardColor.orange),
          _colorSelectionCircle(CardColor.pink),
          _colorSelectionCircle(CardColor.brown),
          _colorSelectionCircle(CardColor.grey),
          SizedBox(width: 6,)

        ],
      ),
    );

  }




  Widget _rightBottomSheetBuilder(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _bottomSheetTile(
              PngIcon(
                fileName: 'outline_delete_black_48.png',
              ),
              'Delete'),
          _bottomSheetTile(
              PngIcon(
                fileName: 'outline_file_copy_black_48.png',
              ),
              'Make a copy'),
          _bottomSheetTile(
              PngIcon(
                fileName: 'outline_share_black_48.png',
              ),
              'Send'),
          _bottomSheetTile(
              PngIcon(
                fileName: 'outline_person_add_black_48.png',
              ),
              'Collaborator'),
          _bottomSheetTile(
              PngIcon(
                fileName: 'outline_label_black_48.png',
              ),
              'Labels'),

          _colorSelectionList()

          





        ],
      ),
    );







  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
        offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
        child: BottomAppBar(
          color: appWhite,
          child: Container(
            height: 48,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                PngIconButton(
                    pngIcon: PngIcon(
                      fileName: 'outline_add_box_black_48.png',
                    ),
                    onTap: () {
                      Scaffold.of(context)
                          .showBottomSheet(_leftBottomSheetBuilder);
                    }),
                PngIconButton(
                    pngIcon: PngIcon(
                      fileName: 'outline_more_vert_black_48.png',
                    ),
                    onTap: () {
                      Scaffold.of(context)
                          .showBottomSheet(_rightBottomSheetBuilder);
                    })
              ],
            ),
          ),
        ));
  }
}
