import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/auth_bloc.dart';
import 'package:keep_notes_clone/custom_widgets/png.dart';
import 'package:keep_notes_clone/main.dart';
import 'package:keep_notes_clone/models/keep_clone_user.dart';
import 'package:keep_notes_clone/notifiers/note_card_mode.dart';
import 'package:keep_notes_clone/screens/note_search_screen.dart';

import 'package:keep_notes_clone/utils/styles.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:provider/provider.dart';

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
  @override
  double get maxExtent => mqScreenSize.width * 0.165 + mqPaddingTop;

  @override
  double get minExtent => mqScreenSize.width * 0.165 + mqPaddingTop;

  @override
  bool shouldRebuild(covariant _MyCustomSearchAppBarDelegate oldDelegate) =>
      false;

  Widget _selectNoteCardModeButton(NoteCardModeSelection notifier) {
    var noteCardMode = notifier.mode;

    var nextModeIconFile = (noteCardMode == NoteCardMode.extended)
        ? 'outline_dashboard_black_48.png'
        : 'outline_view_agenda_black_48.png';

    var nextMode = (noteCardMode == NoteCardMode.extended)
        ? NoteCardMode.small
        : NoteCardMode.extended;

    return PngIconButton(
        key: ValueKey('note_card_mode_button'),
        backgroundColor: appWhite,
        padding: EdgeInsets.all(mqScreenSize.width * 0.019),
        pngIcon: PngIcon(
          size: mqScreenSize.width * 0.058,
          fileName: nextModeIconFile,
        ),
        onTap: () {
          notifier.switchTo(nextMode);
        });
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    var noteCardModeNotifier = Provider.of<NoteCardModeSelection>(context);
    var authBloc = Provider.of<AuthBloc>(context);

    return Container(
      padding: EdgeInsets.only(
          bottom: mqScreenSize.width * 0.019,
          left: mqScreenSize.width * 0.039,
          right: mqScreenSize.width * 0.039),
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: mqScreenSize.width * 0.122,
        width: double.infinity,
        child: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NoteSearchScreen()));
          },
          child: Container(
            key: ValueKey('search_appbar'),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: appWhite,
                boxShadow: [
                  BoxShadow(blurRadius: 1, color: Color.fromRGBO(0, 0, 0, 0.3)),
                ],
                borderRadius:
                    BorderRadius.circular(mqScreenSize.width * 0.019)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      key: ValueKey('home_drawer_burger'),
                      iconSize: mqScreenSize.width * 0.058,
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
                    Text('Search your notes',
                        style: searchAppBarStyle(mqScreenSize.width)),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _selectNoteCardModeButton(noteCardModeNotifier),
                    StreamBuilder<KeepCloneUser>(
                        stream: authBloc.loggedInUser,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            return GestureDetector(
                              onTap: () {
                                authBloc.logout();
                              },
                              child: Container(
                                color: appWhite,
                                padding: EdgeInsets.only(
                                    right: mqScreenSize.width * 0.029,
                                    left: mqScreenSize.width * 0.029),
                                child: CircleAvatar(
                                  radius: mqScreenSize.width * 0.039,
                                  child: Text(
                                    snapshot.data.username[0].toUpperCase(),
                                    style: TextStyle(
                                        fontSize: mqScreenSize.width * 0.034),
                                  ),
                                ),
                              ),
                            );
                          }
                          return Container();
                        }),
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
