import 'package:flutter/material.dart';

import 'package:keep_notes_clone/custom_widgets/png_icon_button.dart';
import 'package:keep_notes_clone/styles.dart';
import 'package:keep_notes_clone/colors.dart';

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
        title: Text('Search your notes', style: searchAppBarStyle),
        titleSpacing: 0,
        actions: <Widget>[
          PngIconButton(
              fileName: 'outline_dashboard_black_48.png',
              size: 25,
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
          )
        ],
        backgroundColor: appWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }
}
