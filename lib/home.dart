import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:keep_notes_clone/styles.dart';

import 'package:keep_notes_clone/custom_widgets/search_appbar.dart';

class HomeScreen extends StatelessWidget {
  Widget bottomNavBar() {
    return Container(
      color: Colors.green,
      height: 50,
    );
  }

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
        statusBarColor: appWhite, statusBarIconBrightness: Brightness.dark));

    return Scaffold(
      backgroundColor: appWhite,
      body: SafeArea(
        child: Container(
          // color: Colors.red[200],
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
      bottomNavigationBar: bottomNavBar(),
    );
  }
}
