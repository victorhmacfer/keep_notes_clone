import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/note_tracking_bloc.dart';
import 'package:keep_notes_clone/custom_widgets/png.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/notifiers/note_creation.dart';
import 'package:keep_notes_clone/notifiers/note_editing.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/utils/styles.dart';
import 'package:provider/provider.dart';

class NoteLabelingScreenForCreate extends StatelessWidget {
  List<Widget> _labelList(List<Label> labels) {
    return labels.map((label) => _NoteLabelListItemForCreate(label)).toList();
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

class NoteLabelingScreenForEdit extends StatelessWidget {
  List<Widget> _labelList(List<Label> labels) {
    return labels.map((label) => _NoteLabelListItemForEdit(label)).toList();
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

class _NoteLabelListItemForCreate extends StatelessWidget {
  final Label label;

  _NoteLabelListItemForCreate(this.label);

  @override
  Widget build(BuildContext context) {
    var notifier = Provider.of<NoteCreationChangeNotifier>(context);

    var labelIsChecked = notifier.futureLabels.contains(label);

    return Container(
      padding: EdgeInsets.only(left: 16, right: 8),
      height: 56,
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
                  label.text,
                  style:
                      drawerItemStyle.copyWith(fontSize: 15, letterSpacing: 0),
                ),
              ],
            ),
            Checkbox(
                value: labelIsChecked,
                onChanged: (newValue) {
                  if (newValue == true) {
                    notifier.checkLabel(label);
                  } else {
                    notifier.uncheckLabel(label);
                  }
                }),
          ]),
    );
  }
}


class _NoteLabelListItemForEdit extends StatelessWidget {
  final Label label;

  _NoteLabelListItemForEdit(this.label);

  @override
  Widget build(BuildContext context) {
    var notifier = Provider.of<NoteEditingChangeNotifier>(context);

    var labelIsChecked = notifier.futureLabels.contains(label);

    return Container(
      padding: EdgeInsets.only(left: 16, right: 8),
      height: 56,
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
                  label.text,
                  style:
                      drawerItemStyle.copyWith(fontSize: 15, letterSpacing: 0),
                ),
              ],
            ),
            Checkbox(
                value: labelIsChecked,
                onChanged: (newValue) {
                  if (newValue == true) {
                    notifier.checkLabel(label);
                  } else {
                    notifier.uncheckLabel(label);
                  }
                }),
          ]),
    );
  }
}
