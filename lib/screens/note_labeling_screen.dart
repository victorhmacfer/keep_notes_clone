import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/note_labeling_bloc.dart';
import 'package:keep_notes_clone/custom_widgets/png.dart';
import 'package:keep_notes_clone/main.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/notifiers/note_setup_screen_controller.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/utils/styles.dart';
import 'package:keep_notes_clone/viewmodels/note_labeling_view_model.dart';
import 'package:provider/provider.dart';

final _labelSearchController = TextEditingController();
final _labelSearchFocusNode = FocusNode();

class NoteLabelingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var noteLabelingBloc = Provider.of<NoteLabelingBloc>(context);

    _labelSearchController.clear();
    noteLabelingBloc.resetLabelNameSearch();

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        title: TextField(
          key: ValueKey('note_labeling_name_textfield'),
          controller: _labelSearchController,
          focusNode: _labelSearchFocusNode,
          cursorWidth: 1,
          onChanged: (text) {
            noteLabelingBloc.onSearchLabelName(text);
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
        child: StreamBuilder<NoteLabelingViewModel>(
            stream: noteLabelingBloc.noteLabelingViewModelStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var showCreateButton = !snapshot.data.foundExactMatch &&
                    _labelSearchController.text.isNotEmpty;

                return _LabelListView(
                    showCreateButton: showCreateButton,
                    searchKeyword: _labelSearchController.text,
                    labels: snapshot.data.labels);
              }
              return Container();
            }),
      ),
    );
  }
}

class _NoteLabelListItem extends StatelessWidget {
  final Label label;

  _NoteLabelListItem(this.label);

  @override
  Widget build(BuildContext context) {
    var notifier = Provider.of<NoteSetupScreenController>(context);

    var labelIsChecked = notifier.futureLabels.any((lab) => lab.id == label.id);

    var screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        if (labelIsChecked) {
          notifier.uncheckLabel(label);
        } else {
          notifier.checkLabel(label);
        }
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 8),
        height: 56,
        color: appWhite,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: screenWidth * 0.8,
                child: Row(
                  children: <Widget>[
                    PngIcon(fileName: 'outline_label_black_48.png'),
                    SizedBox(
                      width: screenWidth * 0.078,
                    ),
                    Expanded(
                      child: Text(
                        label.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: drawerItemStyle(mqScreenSize.width).copyWith(
                            fontSize: 15, letterSpacing: 0),
                      ),
                    ),
                  ],
                ),
              ),
              Checkbox(
                  key: ValueKey('checkbox-${label.name}'),
                  value: labelIsChecked,
                  onChanged: (newValue) {
                    if (newValue == true) {
                      notifier.checkLabel(label);
                    } else {
                      notifier.uncheckLabel(label);
                    }
                  }),
            ]),
      ),
    );
  }
}

class _CreateLabelButton extends StatelessWidget {
  final Key key;
  final String labelText;

  final void Function() onTap;

  _CreateLabelButton(this.labelText, {this.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    var noteLabelingBloc = Provider.of<NoteLabelingBloc>(context);
    var notifier = Provider.of<NoteSetupScreenController>(context);

    return GestureDetector(
      onTap: () async {
        var createdLabel =
            await noteLabelingBloc.onCreateLabelInsideNote(labelText);
        notifier.checkLabel(createdLabel);
        _labelSearchController.clear();
        _labelSearchFocusNode.unfocus();
      },
      child: Container(
        color: appWhite,
        padding: EdgeInsets.symmetric(horizontal: 16),
        height: 56,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.add,
              color: appSettingsBlue,
            ),
            SizedBox(
              width: 32,
            ),
            Expanded(
                child: Text(
              'Create "$labelText"',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: drawerItemStyle(mqScreenSize.width).copyWith(fontSize: 15, letterSpacing: 0),
            ))
          ],
        ),
      ),
    );
  }
}

class _LabelListView extends StatelessWidget {
  final bool showCreateButton;
  final String searchKeyword;
  final List<Label> labels;

  _LabelListView(
      {@required this.showCreateButton,
      @required this.searchKeyword,
      @required this.labels});

  @override
  Widget build(BuildContext context) {
    List<Widget> theChildren = [];
    if (showCreateButton) {
      theChildren.add(_CreateLabelButton(
        searchKeyword,
        key: ValueKey('note_labeling_create_button'),
      ));
    } else {
      theChildren.add(Container());
    }
    if (labels.isNotEmpty) {
      for (var lab in labels) {
        theChildren.add(_NoteLabelListItem(lab));
      }
    }

    return ListView(
      children: theChildren,
    );
  }
}
