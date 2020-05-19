import 'package:keep_notes_clone/custom_widgets/png_icon_button.dart';
import 'package:keep_notes_clone/styles.dart';

import 'package:flutter/material.dart';

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
  static const double APP_BAR_HEIGHT = 68;

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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: AppBar(
        iconTheme: IconThemeData(color: appIconGrey),
        elevation: 2,
        leading: Icon(Icons.menu),
        title: Text('Search your notes',
            style: TextStyle(
                color: appIconGrey, fontFamily: 'Jost', fontSize: 18)),
        titleSpacing: 0,
        actions: <Widget>[
          PngIconButton(fileName: 'outline_view_agenda_black_48.png', onTap: () {}),
          
          //Icon(Icons.dashboard),

          Padding(
            padding: const EdgeInsets.only(right: 12, left: 20),
            child: CircleAvatar(
              radius: 16,
              child: Text(
                'V',
                style: TextStyle(fontSize: 14),
              ),
            ),
          )
        ],
        backgroundColor: appWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }
}
