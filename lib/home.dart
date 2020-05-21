import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keep_notes_clone/custom_widgets/bottom_appbar.dart';
import 'package:keep_notes_clone/custom_widgets/note_card.dart';

import 'package:keep_notes_clone/colors.dart';

import 'package:keep_notes_clone/custom_widgets/search_appbar.dart';

import 'package:keep_notes_clone/custom_widgets/floating_action_button.dart';
import 'package:keep_notes_clone/styles.dart';

class HomeScreen extends StatelessWidget {
  Widget _sliverForNoCardsAdded(double screenHeight) {
    return SliverToBoxAdapter(
      child: Container(
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
      ),
    );
  }

  Widget _sliverForCardsList() {
    return SliverList(
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
        title:
            'very huge title with many words lets see where it breaks or ellipsis overflows',
        color: CardColor.red,
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
    ]));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));

    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: appWhite,
      extendBody: true, // making the bottom bar notch transparent
      floatingActionButton: MyCustomFab(),
      floatingActionButtonLocation: MyCustomFabLocation(),
      bottomNavigationBar: MyBottomAppBar(),
      body: SafeArea(
        // ignoring the bottom safearea is necessary for "extendBody" to work
        bottom: false,
        child: Container(
          child: CustomScrollView(
            slivers: <Widget>[
              SearchAppBar(),

              _sliverForNoCardsAdded(screenHeight),

              // _sliverForCardsList(),
            ],
          ),
        ),
      ),
    );
  }
}
