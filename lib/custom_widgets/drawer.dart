import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/drawer_bloc.dart';
import 'package:keep_notes_clone/blocs/home_bloc.dart';
import 'package:keep_notes_clone/blocs/label_screen_bloc.dart';
import 'package:keep_notes_clone/screens/archive_screen.dart';
import 'package:keep_notes_clone/custom_widgets/png.dart';
import 'package:keep_notes_clone/screens/label_screen.dart';
import 'package:keep_notes_clone/screens/reminders_screen.dart';

import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/screens/edit_labels_screen.dart';
import 'package:keep_notes_clone/home.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/notifiers/drawer_screen_selection.dart';
import 'package:keep_notes_clone/screens/settings_screen.dart';

import 'package:keep_notes_clone/utils/styles.dart';
import 'package:keep_notes_clone/screens/trash_screen.dart';
import 'package:provider/provider.dart';

import 'package:keep_notes_clone/main.dart';

final _selectedBorderRadius = BorderRadius.only(
    topRight: Radius.circular(48), bottomRight: Radius.circular(48));

final _selectedMargin = EdgeInsets.only(right: 8);

const double _drawerItemHeight = 48;

const double _iconToTextSpacing = 16;

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<DrawerBloc>(
      create: (context) => DrawerBloc(repo),
      child: _MyDrawer(),
    );
  }
}

class _MyDrawer extends StatelessWidget {
  // this drawer item indexes (for the notifier to track the selected item) are:
  // 'Notes' item         index 0
  // 'Reminders' item     index 1
  // some label           index 4
  // another label        index 5
  //      ...
  //      ...
  // 'Archive' item       index 2
  // 'Trash' item         index 3

  List<Widget> _labelList(List<Label> labels,
      DrawerScreenSelection drawerScreenSelection, BuildContext context) {
    List<Widget> theList = [];

    for (int i = 0; i < labels.length; i++) {
      var selectableLabelItem = _SelectableDrawerItem(
        key: ValueKey('drawer_label_${labels[i].name}'),
        text: labels[i].name,
        iconFileName: 'outline_label_black_48.png',
        // accounting for the other 4 SELECTABLE drawer items that are not labels
        drawerItemIndex: i + 4,
        onPressed: () {
          if (drawerScreenSelection.selectedScreenIndex != i + 4) {
            drawerScreenSelection.changeSelectedScreenToIndex(i + 4);

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Provider<LabelScreenBloc>(
                          create: (context) => LabelScreenBloc(repo, labels[i]),
                          child: LabelScreen(labels[i]),
                        )));
          }
        },
      );
      theList.add(selectableLabelItem);
    }
    return theList;
  }

  @override
  Widget build(BuildContext context) {
    var drawerBloc = Provider.of<DrawerBloc>(context);
    var drawerScreenSelection = Provider.of<DrawerScreenSelection>(context);

    return Drawer(
      key: ValueKey('drawer'),
      child: ListView(
        children: <Widget>[
          _MyCustomDrawerHeader(),
          _SelectableDrawerItem(
            key: ValueKey('notes_drawer_item'),
            text: 'Notes',
            iconFileName: 'keep-quadrado.png',
            drawerItemIndex: 0,
            onPressed: () {
              if (drawerScreenSelection.selectedScreenIndex != 0) {
                drawerScreenSelection.changeSelectedScreenToIndex(0);

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Provider<HomeBloc>(
                              create: (context) => HomeBloc(repo),
                              child: HomeScreen(),
                            )));
              }
            },
          ),
          _SelectableDrawerItem(
            key: ValueKey('reminders_drawer_item'),
            text: 'Reminders',
            iconFileName: 'outline_notifications_black_48.png',
            drawerItemIndex: 1,
            onPressed: () {
              if (drawerScreenSelection.selectedScreenIndex != 1) {
                drawerScreenSelection.changeSelectedScreenToIndex(1);

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => RemindersScreen()));
              }
            },
          ),
          StreamBuilder<List<Label>>(
              stream: drawerBloc.sortedLabelsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data.isNotEmpty) {
                  return Column(
                    children: <Widget>[
                      Container(
                        key: ValueKey('drawer_labels_edit'),
                        padding: EdgeInsets.only(left: 16, right: 4),
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('LABELS', style: drawerLabelsEditStyle),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditLabelsScreen(
                                              autoFocus: false,
                                            )));
                              },
                              child: Container(
                                color: appWhite,
                                padding: EdgeInsets.all(12),
                                child:
                                    Text('EDIT', style: drawerLabelsEditStyle),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: _labelList(
                            snapshot.data, drawerScreenSelection, context),
                      ),
                    ],
                  );
                }
                return _MyCustomDrawerDivider();
              }),
          _SimpleDrawerItem(
            text: 'Create new label',
            iconFileName: 'outline_add_black_48.png',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditLabelsScreen(autoFocus: true)));
            },
          ),
          _MyCustomDrawerDivider(),
          _SelectableDrawerItem(
            key: ValueKey('archive_drawer_item'),
            text: 'Archive',
            iconFileName: 'outline_archive_black_48.png',
            drawerItemIndex: 2,
            onPressed: () {
              if (drawerScreenSelection.selectedScreenIndex != 2) {
                drawerScreenSelection.changeSelectedScreenToIndex(2);

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => ArchiveScreen()));
              }
            },
          ),
          _SelectableDrawerItem(
            key: ValueKey('trash_drawer_item'),
            text: 'Trash',
            iconFileName: 'outline_delete_black_48.png',
            drawerItemIndex: 3,
            onPressed: () {
              if (drawerScreenSelection.selectedScreenIndex != 3) {
                drawerScreenSelection.changeSelectedScreenToIndex(3);

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => TrashScreen()));
              }
            },
          ),
          _MyCustomDrawerDivider(),
          _SimpleDrawerItem(
            text: 'Settings',
            iconFileName: 'outline_settings_black_48.png',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
          ),
          _SimpleDrawerItem(
            text: 'Help & feedback',
            iconFileName: 'outline_help_outline_black_48.png',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _SelectableDrawerItem extends StatelessWidget {
  final Key key;
  final String text;
  final String iconFileName;
  final int drawerItemIndex;
  final void Function() onPressed;

  _SelectableDrawerItem(
      {@required this.key,
      @required this.text,
      this.iconFileName = 'outline_label_black_48.png',
      @required this.drawerItemIndex,
      @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    // THIS IS TRASH DESIGN but will do for now.
    var pngIcon = (iconFileName == 'keep-quadrado.png')
        ? PngIcon(
            fileName: iconFileName,
            size: 22,
          )
        : PngIcon(fileName: iconFileName);

    var drawerScreenSelection = Provider.of<DrawerScreenSelection>(context);
    var selected = drawerItemIndex == drawerScreenSelection.selectedScreenIndex;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: _drawerItemHeight,
        width: double.infinity,
        padding: EdgeInsets.only(left: 24),
        margin: (selected) ? _selectedMargin : EdgeInsets.zero,
        decoration: BoxDecoration(
            color: (selected) ? appDrawerItemSelected : appWhite,
            borderRadius:
                (selected) ? _selectedBorderRadius : BorderRadius.zero),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            pngIcon,
            SizedBox(
              width: _iconToTextSpacing,
            ),
            Expanded(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: drawerItemStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SimpleDrawerItem extends StatelessWidget {
  final String text;

  final String iconFileName;
  final void Function() onPressed;

  _SimpleDrawerItem(
      {@required this.text,
      @required this.iconFileName,
      @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        color: appWhite,
        height: _drawerItemHeight,
        width: double.infinity,
        padding: EdgeInsets.only(left: 24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PngIcon(fileName: iconFileName),
            SizedBox(
              width: _iconToTextSpacing,
            ),
            Text(
              text,
              style: drawerItemStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class _MyCustomDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      color: appWhite,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.asset(
            'assets/icons/google-logo.png',
            width: 64,
          ),
          Text(
            ' Keep',
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: appIconGrey),
          )
        ],
      ),
    );
  }
}

class _MyCustomDrawerDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: appDividerGrey,
      margin: EdgeInsets.symmetric(vertical: 8),
    );
  }
}
