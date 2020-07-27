import 'package:flutter/material.dart';
import 'package:keep_notes_clone/custom_widgets/png.dart';
import 'package:keep_notes_clone/screens/note_search_screen.dart';

import 'package:keep_notes_clone/utils/styles.dart';
import 'package:keep_notes_clone/utils/colors.dart';

class SearchAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      floating: true,
      delegate: _MyCustomSearchAppBarDelegate(),
    );
  }
}

class _MyCustomSearchAppBarDelegate extends SliverPersistentHeaderDelegate {
  static const double APP_BAR_HEIGHT = 92;

  @override
  double get maxExtent => APP_BAR_HEIGHT;

  @override
  double get minExtent => APP_BAR_HEIGHT;

  @override
  bool shouldRebuild(covariant _MyCustomSearchAppBarDelegate oldDelegate) =>
      false;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: EdgeInsets.only(bottom: 8, left: 16, right: 16),
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NoteSearchScreen()));
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: appWhite,
                boxShadow: [
                  BoxShadow(blurRadius: 1, color: Color.fromRGBO(0, 0, 0, 0.3)),
                ],
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: appIconGrey,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text('Search your notes', style: searchAppBarStyle),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    PngIconButton(
                        pngIcon: PngIcon(
                          fileName: 'outline_dashboard_black_48.png',
                        ),
                        onTap: () {}),
                    Padding(
                      padding: const EdgeInsets.only(right: 12, left: 20),
                      child: CircleAvatar(
                        radius: 16,
                        child: Text(
                          'V',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
