import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keep_notes_clone/custom_widgets/bottom_appbar.dart';
import 'package:keep_notes_clone/custom_widgets/drawer.dart';
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
        color: NoteColor.white,
      ),
      NoteCard(
        title: 'filmes para ver',
        text: 'diamante de sangue',
        color: NoteColor.white,
      ),
      NoteCard(
        title:
            'very huge title with many words lets see where it breaks or ellipsis overflows',
        color: NoteColor.red,
      ),
      NoteCard(
        title: 'only title',
        color: NoteColor.brown,
      ),
      NoteCard(
        title:
            'very very very extremely large title that should be put in the card correctly',
        text: 'some small text',
        color: NoteColor.darkBlue,
      ),
      NoteCard(
        text:
            'A very very very very big text that should be put inside the card and fit correctly.',
        color: NoteColor.white,
      ),
      NoteCard(
        text:
            'A very very very very big text thatshould be put inside the card and fit correctlyqiudhquiwdhquihduiqdhuiqdhuiqdhuidqhdqsduiashuiashas',
        color: NoteColor.purple,
      ),
      NoteCard(
        title: 'small title',
        text: 'some small text',
        color: NoteColor.white,
      ),
      NoteCard(
        title: 'filmes para ver',
        text: 'diamante de sangue',
        color: NoteColor.white,
      ),
      NoteCard(
        title: 'my new note with huge text',
        text:
            'oijdoqjisdoi qjsoiqjsdoqjs qjsoi qjsoiqsqsdjqsqs oqisjdoiqsj doiqsjd oiqs jdoiqs doiqs jdoiqjs qjsdojqjqs jq djqsoi doqis jdoiqsjdoqjs oiqsd qsidqs uiqhsd qhuisd quisdhuiqshduiqhsdu qsuiqhsduqishd quiqhsduqhsd qs uidhqsui dhquisdu qsuquisdhquishd qsdqhsuhqsui duiqhsduiqhsdu quidh quisdqhs dqhusqs uiqhsd qsui hquis qsduiqsdquisdh qshduidqsu qsuid uiqsdihsui dhq suid hquis duisqdhqushdqs uiqshduiqsh uidh uid qsuihqsuid quisdhuiq hq quisdqhs dqhusqs uiqhsd qsui hquis qsduiqsdquisdh qshduidqsu qsuid QUEOTA dhq suid hquis duisqdhqushdqs uiqshduiqsh uidh uid qsuihqsuid quisdhuiq hq quisdqhs dqhusqs uiqhsd qsui hquis qsduiqsdquisdh qshduidqsu qsuid uiqsdihsui dhq suid hquis duisqdhqushdqs uiqshduiqsh uidh uid qsuihqsuid quisdhuiq hQUEOTA',
        color: NoteColor.brown,
      ),
      NoteCard(
        title:
            'very very very extremely large title that should be put in the card correctly',
        text: 'some small text',
        color: NoteColor.darkBlue,
      ),
      NoteCard(
        text:
            'A very very very very big text that should be put inside the card and fit correctly.',
        color: NoteColor.white,
      ),
      NoteCard(
        text:
            'A very very very very big text thatshould be put inside the card and fit correctlyqiudhquiwdhquihduiqdhuiqdhuiqdhuidqhdqsduiashuiashas',
        color: NoteColor.purple,
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
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            MyCustomDrawerHeader(),
            SelectableDrawerItem(
              'Notes',
              iconFileName: 'keep-quadrado.png',
              selected: true,
            ),
            SelectableDrawerItem(
              'Reminders',
              iconFileName: 'outline_notifications_black_48.png',
              selected: false,
            ),
            Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('LABELS', style: drawerLabelsEditStyle),
                      Text('EDIT', style: drawerLabelsEditStyle),
                    ],
                  ),
                ),
                SelectableDrawerItem(
                  'duvidas',
                  selected: false,
                ),
                SelectableDrawerItem(
                  'investimentos',
                  selected: true,
                ),
                SelectableDrawerItem(
                  'duvidas',
                  selected: false,
                ),
                SelectableDrawerItem(
                  'investimentos',
                  selected: true,
                ),
                SelectableDrawerItem(
                  'duvidas',
                  selected: false,
                ),
                SelectableDrawerItem(
                  'investimentos',
                  selected: true,
                ),
                SelectableDrawerItem(
                  'duvidas',
                  selected: false,
                ),
                SelectableDrawerItem(
                  'investimentos',
                  selected: true,
                ),
                SelectableDrawerItem(
                  'duvidas',
                  selected: false,
                ),
                SelectableDrawerItem(
                  'investimentos',
                  selected: true,
                ),
                SelectableDrawerItem(
                  'duvidas',
                  selected: false,
                ),
                SelectableDrawerItem(
                  'investimentos',
                  selected: true,
                ),
              ],
            ),
            SimpleDrawerItem(
                text: 'Create new label',
                iconFileName: 'outline_add_black_48.png'),
            MyCustomDrawerDivider(),
            SelectableDrawerItem(
              'Archive',
              iconFileName: 'outline_archive_black_48.png',
              selected: false,
            ),
            SelectableDrawerItem(
              'Trash',
              iconFileName: 'outline_delete_black_48.png',
              selected: false,
            ),
            MyCustomDrawerDivider(),
            SimpleDrawerItem(
                text: 'Settings',
                iconFileName: 'outline_settings_black_48.png'),
            SimpleDrawerItem(
                text: 'Help & feedback',
                iconFileName: 'outline_help_outline_black_48.png'),
          ],
        ),
      ),
      body: SafeArea(
        // ignoring the bottom safearea is necessary for "extendBody" to work
        bottom: false,
        child: Container(
          child: CustomScrollView(
            slivers: <Widget>[
              SearchAppBar(),

              // _sliverForNoCardsAdded(screenHeight),

              _sliverForCardsList(),
            ],
          ),
        ),
      ),
    );
  }
}
