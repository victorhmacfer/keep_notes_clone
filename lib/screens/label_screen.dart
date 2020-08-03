import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/note_tracking_bloc.dart';
import 'package:keep_notes_clone/custom_widgets/bottom_appbar.dart';
import 'package:keep_notes_clone/custom_widgets/drawer.dart';
import 'package:keep_notes_clone/custom_widgets/floating_action_button.dart';
import 'package:keep_notes_clone/custom_widgets/note_card_grids.dart';
import 'package:keep_notes_clone/custom_widgets/png.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/notifiers/note_card_mode.dart';
import 'package:keep_notes_clone/screens/no_screen.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/utils/styles.dart';
import 'package:keep_notes_clone/viewmodels/label_view_model.dart';
import 'package:provider/provider.dart';

class LabelScreen extends StatelessWidget {
  final Label label;

  LabelScreen(this.label);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appWhite,
      extendBody: true,
      floatingActionButton: MyCustomFab(label: label),
      floatingActionButtonLocation: MyCustomFabLocation(),
      bottomNavigationBar: MyNotchedBottomAppBar(),
      drawer: MyDrawer(),
      body: _Body(label),
    );
  }
}

const double _bottomPadding = 56;

class _Body extends StatelessWidget {
  final Label label;

  _Body(this.label);

  Widget _selectNoteCardModeButton(NoteCardModeSelection notifier) {
    if (notifier.mode == NoteCardMode.extended) {
      return PngIconButton(
        backgroundColor: appWhite,
          pngIcon: PngIcon(
            fileName: 'outline_dashboard_black_48.png',
          ),
          onTap: () {
            notifier.switchTo(NoteCardMode.small);
          });
    }
    return PngIconButton(
      backgroundColor: appWhite,
        pngIcon: PngIcon(
          fileName: 'outline_view_agenda_black_48.png',
        ),
        onTap: () {
          notifier.switchTo(NoteCardMode.extended);
        });
  }

  @override
  Widget build(BuildContext context) {
    var notifier = Provider.of<NoteCardModeSelection>(context);

    return SafeArea(
        bottom: false,
        child: Container(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                floating: true,
                backgroundColor: appWhite,
                iconTheme: IconThemeData(color: appIconGrey),
                title: Text(
                  label.name,
                  style:
                      drawerItemStyle.copyWith(fontSize: 18, letterSpacing: 0),
                ),
                actions: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: PngIconButton(
                      backgroundColor: appWhite,
                        pngIcon:
                            PngIcon(fileName: 'baseline_search_black_48.png'),
                        onTap: () {}),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: _selectNoteCardModeButton(notifier),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: PngIconButton(
                      backgroundColor: appWhite,
                        pngIcon:
                            PngIcon(fileName: 'outline_more_vert_black_48.png'),
                        onTap: () {}),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: _StreamBuilderBody(),
              ),
            ],
          ),
        ));
  }
}

class _StreamBuilderBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var noteBloc = Provider.of<NoteTrackingBloc>(context);
    var modeNotifier = Provider.of<NoteCardModeSelection>(context);

    return StreamBuilder<LabelViewModel>(
        stream: noteBloc.labelViewModelStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var pinnedNotes = snapshot.data.pinned;
            var unpinnedNotes = snapshot.data.unpinned;
            var archivedNotes = snapshot.data.archived;

            var hasAnyNote = pinnedNotes.isNotEmpty ||
                unpinnedNotes.isNotEmpty ||
                archivedNotes.isNotEmpty;

            var onlyHasUnpinnedNotes =
                hasAnyNote && (pinnedNotes.isEmpty && archivedNotes.isEmpty);

            if (hasAnyNote) {
              if (onlyHasUnpinnedNotes) {
                return Container(
                  margin: EdgeInsets.only(bottom: _bottomPadding),
                  child: OptionalSection(
                    mode: modeNotifier.mode,
                    noSpacer: true,
                    notes: unpinnedNotes,
                  ),
                );
              }
              return Container(
                margin: EdgeInsets.only(bottom: _bottomPadding),
                child: Column(
                  children: <Widget>[
                    OptionalSection(
                      title: 'PINNED',
                      mode: modeNotifier.mode,
                      spaceBelow: true,
                      notes: pinnedNotes,
                    ),
                    OptionalSection(
                      title: 'OTHERS',
                      mode: modeNotifier.mode,
                      spaceBelow: true,
                      notes: unpinnedNotes,
                    ),
                    OptionalSection(
                      title: 'ARCHIVED',
                      mode: modeNotifier.mode,
                      notes: archivedNotes,
                      noSpacer: true,
                    ),
                  ],
                ),
              );
            }
            return NoLabelsScreen();
          }
          return Container();
        });
  }
}
