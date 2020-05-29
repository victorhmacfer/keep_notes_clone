import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keep_notes_clone/custom_widgets/bottom_appbar.dart';
import 'package:keep_notes_clone/custom_widgets/drawer.dart';
import 'package:keep_notes_clone/custom_widgets/note_card.dart';

import 'package:keep_notes_clone/colors.dart';

import 'package:keep_notes_clone/custom_widgets/search_appbar.dart';

import 'package:keep_notes_clone/custom_widgets/floating_action_button.dart';
import 'package:keep_notes_clone/styles.dart';
import 'package:provider/provider.dart';

import 'package:keep_notes_clone/blocs/note_tracking_bloc.dart';

import 'models/note.dart';

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
      bottomNavigationBar: MyBottomAppBar(),
      drawer: MyDrawer(),
      body: HomeBody(),
    );
  }
}

class HomeBody extends StatelessWidget {
  Widget _noteCardBuilder(Note note) {
    return NoteCard(
      title: note.title,
      text: note.text,
      color: NoteColor.getNoteColorFromIndex(note.colorIndex),
    );
  }

  @override
  Widget build(BuildContext context) {
    var noteBloc = Provider.of<NoteTrackingBloc>(context);

    var screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      // ignoring the bottom safearea is necessary for "extendBody" to work
      bottom: false,
      child: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SearchAppBar(),
            SliverToBoxAdapter(
              child: StreamBuilder(
                  stream: noteBloc.noteListStream,
                  builder: (context, AsyncSnapshot<List<Note>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.isNotEmpty) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 56),
                          child: Column(
                            children:
                                snapshot.data.map(_noteCardBuilder).toList(),
                          ),
                        );
                      }
                      return Container(
                        height: screenHeight * 0.8,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image.asset(
                              'assets/icons/keep-logo.png',
                              height: 100,
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            Text(
                              'Notes you add appear here',
                              style: cardSmallTextStyle,
                            ),
                          ],
                        ),
                      );
                    }
                    //FIXME:
                    // I duplicated this here temporarily just to have this pretty screen
                    // before adding the first note.
                    // When I start to user the DB I'll remove this.
                    return Container(
                      height: screenHeight * 0.8,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.asset(
                            'assets/icons/keep-logo.png',
                            height: 100,
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Text(
                            'Notes you add appear here',
                            style: cardSmallTextStyle,
                          ),
                        ],
                      ),
                    );

                    // return CircularProgressIndicator(); //FIXME: put this to work later
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
