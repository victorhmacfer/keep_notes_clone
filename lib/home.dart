import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:keep_notes_clone/styles.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: appWhite,
          statusBarIconBrightness: Brightness.dark
        ));




    return Material(
      child: Container(
        color: appWhite,
      ),
      
    );
  }
}