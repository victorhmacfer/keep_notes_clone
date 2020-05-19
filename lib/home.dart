import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keep_notes_clone/custom_widgets/bottom_appbar.dart';

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
        statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark));

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
                fakeSliverItem(),
                fakeSliverItem(),
                fakeSliverItem(),
                fakeSliverItem(),
                fakeSliverItem(),
                fakeSliverItem(),
                fakeSliverItem(),
                fakeSliverItem(),
                fakeSliverItem(),
                fakeSliverItem(),
                fakeSliverItem(),
                fakeSliverItem(),
                fakeSliverItem(),
                fakeSliverItem(),
              ],
            ),
          ),
        ),
        floatingActionButton: MyCustomFab(),
        floatingActionButtonLocation: MyCustomFabLocation(),
        bottomNavigationBar: MyBottomAppBar());
  }
}
