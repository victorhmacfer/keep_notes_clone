import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keep_notes_clone/custom_widgets/bottom_appbar.dart';
import 'package:keep_notes_clone/custom_widgets/card_type_section_title.dart';
import 'package:keep_notes_clone/custom_widgets/chip.dart';
import 'package:keep_notes_clone/custom_widgets/drawer.dart';
import 'package:keep_notes_clone/custom_widgets/note_card.dart';
import 'package:keep_notes_clone/models/label.dart';

import 'package:keep_notes_clone/utils/colors.dart';

import 'package:keep_notes_clone/custom_widgets/search_appbar.dart';

import 'package:keep_notes_clone/custom_widgets/floating_action_button.dart';
import 'package:keep_notes_clone/screens/no_screen.dart';
import 'package:keep_notes_clone/utils/styles.dart';
import 'package:keep_notes_clone/viewmodels/home_view_model.dart';
import 'package:provider/provider.dart';

import 'package:keep_notes_clone/blocs/note_tracking_bloc.dart';

import 'package:keep_notes_clone/models/note.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));

    return Scaffold(
      backgroundColor: appWhite,
      extendBody: true, // making the bottom bar notch transparent
      floatingActionButton: MyCustomFab(),
      floatingActionButtonLocation: MyCustomFabLocation(),
      bottomNavigationBar: MyNotchedBottomAppBar(),
      drawer: MyDrawer(),
      // body: _HomeBody(),
      body: BodyForTestingCrazyGrid(),
    );
  }
}

class MeasuringBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      color: Colors.red[100],
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              color: Colors.green[200],
              width: 100,
              child: NoteCardLabelChip('primeira')),
          Container(
            height: 24,
            width: 80,
            color: Colors.blue[200],
          ),
        ],
      ),
    );
  }
}

class BodyForTestingCrazyGrid extends StatelessWidget {
  static const double _bottomPadding = 56;

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();

    var onlyTitle = Note(
        title: 'pequeno titulo',
        lastEdited: now,
        colorIndex: NoteColor.red.index);

    var titleAndSmallText = Note(
        title: 'pequeno titulo',
        text: 'queota xab',
        lastEdited: now,
        colorIndex: NoteColor.blue.index);

    var onlySmallText = Note(
        text: 'pequeno titulopequeno titulo',
        lastEdited: now,
        colorIndex: NoteColor.green.index);

    var onlyDoubleLineTitle = Note(
        title: 'titulo muito enorme vambora vamo nessa queota xab',
        lastEdited: now,
        colorIndex: NoteColor.purple.index);

    var onlyHugeText = Note(
        text:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris eget metus erat. In ornare tincidunt urna, et mattis mauris imperdiet non. Lorem ipsum dolor sit amet, consectetur adipiscing elit.  ',
        lastEdited: now,
        colorIndex: NoteColor.white.index);

    var onlyTooBigText = Note(
        text:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris eget metus erat. In ornare tincidunt urna, et mattis mauris imperdiet non.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris eget metus erat. In ornare tincidunt urna, et mattis mauris imperdiet non.',
        lastEdited: now,
        colorIndex: NoteColor.darkBlue.index);

    var titleTextAndReminder = Note(
      title: 'Lorem ipsum dolor',
      text:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris eget metus erat. In ornare tincidunt urna, et mattis mauris imperdiet non.Lorem ipsum',
      lastEdited: now,
      colorIndex: NoteColor.pink.index,
      reminderTime: now.add(Duration(minutes: 30)),
    );

    var everythingPossible = Note(
      title: 'Lorem ipsum dolor',
      text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris eget metus erat. In ornare tincidunt urna, et mattis mauris imperdietit amet, consectetur adipiscing elit. Mauris eget metus eit amet, consectetur adipiscing elit. Mauris eget metus e',
      lastEdited: now,
      colorIndex: NoteColor.brown.index,
      reminderTime: now.add(Duration(minutes: 100)),
      labels: [Label(name: 'queota'), Label(name: 'abc'), Label(name: 'pindamonhangaba'), Label(name: 'queota'),]
    );

    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SearchAppBar(),
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(left: 8, bottom: _bottomPadding),
                color: Colors.grey,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          CrazyGridNoteCard(onlyTitle),
                          CrazyGridNoteCard(titleAndSmallText),
                          CrazyGridNoteCard(onlySmallText),
                          CrazyGridNoteCard(onlyTooBigText),
                          CrazyGridNoteCard(everythingPossible),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          CrazyGridNoteCard(onlyDoubleLineTitle),
                          CrazyGridNoteCard(onlyHugeText),
                          CrazyGridNoteCard(titleTextAndReminder),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget _noteCardBuilder(Note note) => NoteCard(note: note);

// class _HomeBody extends StatelessWidget {
//   static const double _bottomPadding = 56;

//   @override
//   Widget build(BuildContext context) {
//     var noteBloc = Provider.of<NoteTrackingBloc>(context);

//     return SafeArea(
//       // ignoring the bottom safearea is necessary for "extendBody" to work
//       top: false,
//       bottom: false,
//       child: Container(
//         child: CustomScrollView(
//           slivers: <Widget>[
//             SearchAppBar(),
//             SliverToBoxAdapter(
//               child: StreamBuilder<HomeViewModel>(
//                 stream: noteBloc.homeViewModelStream,
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     var pinnedNotes = snapshot.data.pinned;
//                     var unpinnedNotes = snapshot.data.unpinned;

//                     if (pinnedNotes.isNotEmpty || unpinnedNotes.isNotEmpty) {
//                       if (pinnedNotes.isEmpty) {
//                         return Container(
//                           margin: EdgeInsets.only(bottom: _bottomPadding),
//                           child: Column(
//                             children:
//                                 unpinnedNotes.map(_noteCardBuilder).toList(),
//                           ),
//                         );
//                       }

//                       return Container(
//                         margin: EdgeInsets.only(bottom: _bottomPadding),
//                         child: Column(
//                           children: <Widget>[
//                             CardTypeSectionTitle('PINNED'),
//                             Column(
//                               children:
//                                   pinnedNotes.map(_noteCardBuilder).toList(),
//                             ),
//                             _OthersColumn(unpinnedNotes),
//                           ],
//                         ),
//                       );
//                     }
//                     return NoNotesScreen();
//                   }

//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _OthersColumn extends StatelessWidget {
//   final List<Note> unpinnedNotesList;

//   _OthersColumn(this.unpinnedNotesList);

//   @override
//   Widget build(BuildContext context) {
//     if (unpinnedNotesList.isEmpty) {
//       return Container();
//     }

//     return Column(
//       children: <Widget>[
//         SizedBox(
//           height: 24,
//         ),
//         CardTypeSectionTitle('OTHERS'),
//         Column(
//           children: unpinnedNotesList.map(_noteCardBuilder).toList(),
//         ),
//       ],
//     );
//   }
// }
