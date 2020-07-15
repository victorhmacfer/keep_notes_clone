import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/note_tracking_bloc.dart';
import 'package:keep_notes_clone/custom_widgets/bottom_appbar.dart';
import 'package:keep_notes_clone/custom_widgets/card_type_section_title.dart';
import 'package:keep_notes_clone/custom_widgets/drawer.dart';
import 'package:keep_notes_clone/custom_widgets/floating_action_button.dart';
import 'package:keep_notes_clone/custom_widgets/note_card.dart';
import 'package:keep_notes_clone/custom_widgets/png.dart';
import 'package:keep_notes_clone/models/note.dart';
import 'package:keep_notes_clone/screens/no_reminders_screen.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/utils/styles.dart';
import 'package:keep_notes_clone/viewmodels/reminders_view_model.dart';
import 'package:provider/provider.dart';

class RemindersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appWhite,
      extendBody: true,
      floatingActionButton: MyCustomFab(),
      floatingActionButtonLocation: MyCustomFabLocation(),
      bottomNavigationBar: MyNotchedBottomAppBar(),
      drawer: MyDrawer(),
      body: _Body(),
    );
  }
}

Widget _noteCardBuilder(Note note) => NoteCard(note: note);

class _Body extends StatelessWidget {
  static const double _bottomPadding = 56;

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
                  'Reminders',
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
                ],
              ),
              SliverToBoxAdapter(
                child: StreamBuilder<RemindersViewModel>(
                    stream: noteBloc.remindersViewModelStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        print('entrei no reminders has data..');
                        var firedReminderNotes = snapshot.data.fired;
                        var upcomingReminderNotes = snapshot.data.upcoming;

                        if (firedReminderNotes.isNotEmpty ||
                            upcomingReminderNotes.isNotEmpty) {
                          return Container(
                            margin: EdgeInsets.only(bottom: _bottomPadding),
                            child: Column(
                              children: <Widget>[
                                _OptionalColumn('FIRED',
                                    notes: firedReminderNotes),
                                _OptionalColumn('UPCOMING',
                                    notes: upcomingReminderNotes),
                              ],
                            ),
                          );
                        }

                        return NoRemindersScreen();
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
