import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/auth_bloc.dart';
import 'package:keep_notes_clone/custom_widgets/png.dart';
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
  static const double APP_BAR_HEIGHT = 92;

  @override
  double get maxExtent => APP_BAR_HEIGHT;

  @override
  double get minExtent => APP_BAR_HEIGHT;

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
        padding: EdgeInsets.all(8),
        pngIcon: PngIcon(
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
            key: ValueKey('search_appbar'),
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
                      key: ValueKey('home_drawer_burger'),
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
                                padding:
                                    const EdgeInsets.only(right: 12, left: 12),
                                child: CircleAvatar(
                                  radius: 16,
                                  child: Text(
                                    snapshot.data.username[0].toUpperCase(),
                                    style: TextStyle(fontSize: 14),
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
