import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/note_tracking_bloc.dart';
import 'package:keep_notes_clone/custom_widgets/png.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/utils/styles.dart';
import 'package:provider/provider.dart';

class NoteLabelsScreen extends StatelessWidget {
  List<Widget> _labelList(List<Label> labels) {
    return labels
        .map((label) => NoteLabelListItem(
              title: label.text,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    var noteTrackingBloc = Provider.of<NoteTrackingBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          cursorWidth: 1,
          cursorColor: appIconGrey,
          decoration: InputDecoration.collapsed(hintText: 'Enter label name'),
        ),
        iconTheme: IconThemeData(color: appIconGrey),
        backgroundColor: appWhite,
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        color: appWhite,
        child: StreamBuilder<List<Label>>(
            stream: noteTrackingBloc.labelListStream,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data.isNotEmpty) {
                return ListView(
                  children: _labelList(snapshot.data),
                );
              }
              return Container();
            }),
      ),
    );
  }
}

class NoteLabelListItem extends StatelessWidget {
  final String title;

  NoteLabelListItem({this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 8),
      height: 56,
      // width: double.infinity,
      color: appWhite,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                PngIcon(fileName: 'outline_label_black_48.png'),
                SizedBox(
                  width: 32,
                ),
                Text(
                  title,
                  style:
                      drawerItemStyle.copyWith(fontSize: 15, letterSpacing: 0),
                ),
              ],
            ),
            Checkbox(value: false, onChanged: (v) {}),
          ]),
    );
  }
}
