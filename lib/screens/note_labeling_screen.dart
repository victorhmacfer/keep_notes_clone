import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/note_tracking_bloc.dart';
import 'package:keep_notes_clone/custom_widgets/png.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/models/label_search_result.dart';
import 'package:keep_notes_clone/notifiers/note_creation.dart';
import 'package:keep_notes_clone/notifiers/note_editing.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/utils/styles.dart';
import 'package:provider/provider.dart';

class NoteLabelingScreenForCreate extends StatelessWidget {
  final labelSearchController = TextEditingController();

  List<Widget> _labelList(bool showCreateButton, List<Label> labels) {
    List<Widget> finalList = [];
    if (showCreateButton) {
      finalList.add(Container(
        color: Colors.red[100],
        height: 56,
      ));
    } else {
      finalList.add(Container());
    }
    for (var lab in labels) {
      finalList.add(_NoteLabelListItemForCreate(lab));
    }
    return finalList;
  }

  @override
  Widget build(BuildContext context) {
    var noteTrackingBloc = Provider.of<NoteTrackingBloc>(context);
    noteTrackingBloc.onResetLabelSearch();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: labelSearchController,
          cursorWidth: 1,
          onChanged: (text) {
            noteTrackingBloc.onSearchLabel(text);
          },
          cursorColor: appIconGrey,
          decoration: InputDecoration.collapsed(hintText: 'Enter label name'),
        ),
        iconTheme: IconThemeData(color: appIconGrey),
        backgroundColor: appWhite,
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        color: appWhite,
        child: StreamBuilder<LabelSearchResult>(
            stream: noteTrackingBloc.labelSearchResultStream,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data.labels.isNotEmpty) {
                var showCreateButton = !snapshot.data.foundExactMatch &&
                    labelSearchController.text.isNotEmpty;
                return ListView(
                  children: _labelList(showCreateButton, snapshot.data.labels),
                );
              }
              return Container();
            }),
      ),
    );
  }
}

class NoteLabelingScreenForEdit extends StatelessWidget {
  final labelSearchController = TextEditingController();

  List<Widget> _labelList(bool showCreateButton, List<Label> labels) {
    List<Widget> finalList = [];
    if (showCreateButton) {
      finalList.add(Container(
        color: Colors.red[100],
        height: 56,
      ));
    } else {
      finalList.add(Container());
    }
    for (var lab in labels) {
      finalList.add(_NoteLabelListItemForEdit(lab));
    }
    return finalList;
  }

  @override
  Widget build(BuildContext context) {
    var noteTrackingBloc = Provider.of<NoteTrackingBloc>(context);
    noteTrackingBloc.onResetLabelSearch();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: labelSearchController,
          cursorWidth: 1,
          onChanged: (text) {
            noteTrackingBloc.onSearchLabel(text);
          },
          cursorColor: appIconGrey,
          decoration: InputDecoration.collapsed(hintText: 'Enter label name'),
        ),
        iconTheme: IconThemeData(color: appIconGrey),
        backgroundColor: appWhite,
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        color: appWhite,
        child: StreamBuilder<LabelSearchResult>(
            stream: noteTrackingBloc.labelSearchResultStream,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data.labels.isNotEmpty) {
                var showCreateButton = !snapshot.data.foundExactMatch &&
                    labelSearchController.text.isNotEmpty;
                return ListView(
                  children: _labelList(showCreateButton, snapshot.data.labels),
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
