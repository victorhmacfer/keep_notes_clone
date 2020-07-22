import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/note_tracking_bloc.dart';
import 'package:keep_notes_clone/custom_widgets/bottom_appbar.dart';
import 'package:keep_notes_clone/custom_widgets/card_type_section_title.dart';
import 'package:keep_notes_clone/custom_widgets/drawer.dart';
import 'package:keep_notes_clone/custom_widgets/floating_action_button.dart';
import 'package:keep_notes_clone/custom_widgets/note_card.dart';
import 'package:keep_notes_clone/custom_widgets/png.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/models/note.dart';
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

Widget _noteCardBuilder(Note note) => NoteCard(note: note);

class _Body extends StatelessWidget {
  static const double _bottomPadding = 56;

  final Label label;

  _Body(this.label);

  @override
  Widget build(BuildContext context) {
    var noteBloc = Provider.of<NoteTrackingBloc>(context);

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
                        pngIcon:
                            PngIcon(fileName: 'baseline_search_black_48.png'),
                        onTap: () {}),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: PngIconButton(
                        pngIcon:
                            PngIcon(fileName: 'outline_dashboard_black_48.png'),
                        onTap: () {}),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: PngIconButton(
                        pngIcon:
                            PngIcon(fileName: 'outline_more_vert_black_48.png'),
                        onTap: () {}),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: StreamBuilder<LabelViewModel>(
                    stream: noteBloc.labelViewModelStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var pinnedNotes = snapshot.data.pinned;
                        var unpinnedNotes = snapshot.data.unpinned;
                        var archivedNotes = snapshot.data.archived;

                        if (pinnedNotes.isEmpty && archivedNotes.isEmpty) {
                          if (unpinnedNotes.isNotEmpty) {
                            return Container(
                              margin: EdgeInsets.only(bottom: _bottomPadding),
                              child: Column(
                                children: unpinnedNotes
                                    .map(_noteCardBuilder)
                                    .toList(),
                              ),
                            );
                          }
                          return NoLabelsScreen();
                        }

                        return Container(
                          margin: EdgeInsets.only(bottom: _bottomPadding),
                          child: Column(
                            children: <Widget>[
                              _OptionalColumn('PINNED', notes: pinnedNotes),
                              _OptionalColumn('OTHERS', notes: unpinnedNotes),
                              _OptionalColumn('ARCHIVED', notes: archivedNotes),
                            ],
                          ),
                        );
                      }
                      return Container();
                    }),
              ),
            ],
          ),
        ));
  }
}


class _OptionalColumn extends StatelessWidget {
  final List<Note> notes;
  final String title;

  _OptionalColumn(this.title, {@required this.notes});

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return Container();
    }

    return Column(
      children: <Widget>[
        CardTypeSectionTitle(title),
        Column(
          children: notes.map(_noteCardBuilder).toList(),
        ),
        SizedBox(
          height: 24,
        ),
      ],
    );
  }
}
