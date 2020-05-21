import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keep_notes_clone/custom_widgets/bottom_appbar.dart';
import 'package:keep_notes_clone/custom_widgets/note_card.dart';

import 'package:keep_notes_clone/styles.dart';

import 'package:keep_notes_clone/custom_widgets/search_appbar.dart';

import 'package:keep_notes_clone/custom_widgets/floating_action_button.dart';

class HomeScreen extends StatelessWidget {
  Widget fakeSliverItem() {
    return SliverPadding(
      padding: EdgeInsets.all(12),
      sliver: SliverAppBar(
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));

    return Scaffold(
        backgroundColor: appWhite,
        extendBody: true, // making the bottom bar notch transparent
        body: SafeArea(
          // ignoring the bottom safearea is necessary for "extendBody" to work
          bottom: false,
          child: Container(
            child: CustomScrollView(
              slivers: <Widget>[
                SearchAppBar(),
                SliverList(
                    delegate: SliverChildListDelegate([
                  NoteCard(
                    title: 'small title',
                    text: 'some small text',
                    color: CardColor.white,
                  ),
                  NoteCard(
                    title: 'filmes para ver',
                    text: 'diamante de sangue',
                    color: CardColor.white,
                  ),
                  NoteCard(
                    title: 'only title',
                    color: CardColor.brown,
                  ),
                  NoteCard(
                    title:
                        'very very very extremely large title that should be put in the card correctly',
                    text: 'some small text',
                    color: CardColor.darkBlue,
                  ),
                  NoteCard(
                    text:
                        'A very very very very big text that should be put inside the card and fit correctly.',
                    color: CardColor.white,
                  ),
                  NoteCard(
                    text:
                        'A very very very very big text thatshould be put inside the card and fit correctlyqiudhquiwdhquihduiqdhuiqdhuiqdhuidqhdqsduiashuiashas',
                    color: CardColor.purple,
                  ),
                  NoteCard(
                    title: 'small title',
                    text: 'some small text',
                    color: CardColor.white,
                  ),
                  NoteCard(
                    title: 'filmes para ver',
                    text: 'diamante de sangue',
                    color: CardColor.white,
                  ),
                  NoteCard(
                    title: 'only title',
                    color: CardColor.brown,
                  ),
                  NoteCard(
                    title:
                        'very very very extremely large title that should be put in the card correctly',
                    text: 'some small text',
                    color: CardColor.darkBlue,
                  ),
                  NoteCard(
                    text:
                        'A very very very very big text that should be put inside the card and fit correctly.',
                    color: CardColor.white,
                  ),
                  NoteCard(
                    text:
                        'A very very very very big text thatshould be put inside the card and fit correctlyqiudhquiwdhquihduiqdhuiqdhuiqdhuidqhdqsduiashuiashas',
                    color: CardColor.purple,
                  ),
                  SizedBox(
                    height: 56,
                  )
                ])),
              ],
            ),
          ),
        ),
        floatingActionButton: MyCustomFab(),
        floatingActionButtonLocation: MyCustomFabLocation(),
        bottomNavigationBar: MyBottomAppBar());
  }
}
