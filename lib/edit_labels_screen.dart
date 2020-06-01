import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/note_tracking_bloc.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/styles.dart';
import 'package:provider/provider.dart';

import 'package:keep_notes_clone/colors.dart';

class EditLabelsScreen extends StatelessWidget {
  List<Widget> _labelList(List<Label> labels) {
    return labels
        .map((label) => EditLabelListItem(
            key: ValueKey(label.text), initialText: label.text))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    var noteTrackingBloc = Provider.of<NoteTrackingBloc>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Edit labels',
          style: drawerItemStyle.copyWith(fontSize: 18, letterSpacing: 0),
        ),
        iconTheme: IconThemeData(color: appIconGrey),
        backgroundColor: appWhite,
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        color: appWhite,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(child: CreateLabelListItem()),
            SliverToBoxAdapter(
              child: StreamBuilder<List<Label>>(
                  stream: noteTrackingBloc.labelListStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data.isNotEmpty) {
                      return Column(
                        children: _labelList(snapshot.data),
                      );
                    }
                    return Container();
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class CreateLabelListItem extends StatefulWidget {
  @override
  _CreateLabelListItemState createState() => _CreateLabelListItemState();
}

class _CreateLabelListItemState extends State<CreateLabelListItem> {
  final newLabelFocusNode = FocusNode();

  bool isFocused;

  TextEditingController newLabelTextController;

  @override
  void initState() {
    super.initState();
    isFocused = true;
    newLabelTextController = TextEditingController();
    newLabelFocusNode.addListener(() {
      setState(() {
        isFocused = newLabelFocusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var noteTrackingBloc = Provider.of<NoteTrackingBloc>(context);

    var fakeBorderColor = (isFocused) ? appDividerGrey : appWhite;

    var myPrefixIconChoice = (isFocused)
        ? IconButton(
            icon: Icon(Icons.clear),
            color: appIconGrey,
            iconSize: 24,
            onPressed: () {
              setState(() {
                newLabelFocusNode.unfocus();
                isFocused = false;
              });
            },
          )
        : IconButton(
            icon: Icon(Icons.add),
            color: appIconGrey,
            iconSize: 28,
            onPressed: () {
              setState(() {
                newLabelFocusNode.requestFocus();
                isFocused = true;
              });
            },
          );

    var paddedPrefixIcon = Container(
      color: appWhite,
      height: 2,
      width: 52,
      margin: EdgeInsets.only(right: 16),
      child: myPrefixIconChoice,
    );

    return Container(
      height: 56,
      padding: EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: appWhite,
        border: Border.symmetric(
            vertical: BorderSide(color: fakeBorderColor, width: 1)),
      ),
      child: TextField(
        controller: newLabelTextController,
        cursorColor: appIconGrey,
        cursorWidth: 1,
        style: drawerItemStyle,
        focusNode: newLabelFocusNode,
        autofocus: true,
        decoration: InputDecoration(
            prefixIcon: paddedPrefixIcon,
            border: InputBorder.none,
            hintStyle: TextStyle(
                fontSize: 15, color: Color.fromARGB(255, 198, 198, 198)),
            hintText: 'Create new label',
            suffixIcon: (isFocused)
                ? IconButton(
                    icon: Icon(Icons.check),
                    color: appIconGrey,
                    onPressed: () {
                      var newLabelText = newLabelTextController.text;
                      if (newLabelText.isNotEmpty) {
                        noteTrackingBloc
                            .onCreateNewLabel(newLabelTextController.text);
                        newLabelTextController.clear();
                      }
                    },
                  )
                : Container(
                    width: 1,
                    height: 1,
                    color: appWhite,
                  )),
      ),
    );
  }
}

class EditLabelListItem extends StatefulWidget {
  final String initialText;

  final ValueKey<String> key;

  EditLabelListItem({this.key, this.initialText});

  @override
  _EditLabelListItemState createState() => _EditLabelListItemState();
}

class _EditLabelListItemState extends State<EditLabelListItem> {
  final itemFocusNode = FocusNode();

  bool isFocused;

  TextEditingController itemTextController;

  @override
  void initState() {
    super.initState();
    isFocused = false;
    itemTextController = TextEditingController(text: widget.initialText);
    itemFocusNode.addListener(() {
      setState(() {
        isFocused = itemFocusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var fakeBorderColor = (isFocused) ? appDividerGrey : appWhite;

    var myPrefixIconChoice = (isFocused)
        ? Icon(
            Icons.delete_outline,
            color: appIconGrey,
            size: 24,
          )
        : Icon(
            Icons.label_outline,
            color: appIconGrey,
            size: 28,
          );

    var paddedPrefixIcon = Container(
      color: appWhite,
      height: 2,
      width: 52,
      margin: EdgeInsets.only(right: 16),
      child: myPrefixIconChoice,
    );

    return Container(
      key: widget.key,
      height: 56,
      padding: EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: appWhite,
        border: Border.symmetric(
            vertical: BorderSide(color: fakeBorderColor, width: 1)),
      ),
      child: TextField(
        controller: itemTextController,
        cursorColor: appIconGrey,
        cursorWidth: 1,
        style: drawerItemStyle,
        focusNode: itemFocusNode,
        decoration: InputDecoration(
            prefixIcon: paddedPrefixIcon,
            border: InputBorder.none,
            suffixIcon: (isFocused)
                ? IconButton(
                    icon: Icon(Icons.check),
                    color: appSettingsBlue,
                    onPressed: () {},
                  )
                : IconButton(
                    icon: Icon(Icons.create),
                    color: appIconGrey,
                    onPressed: () {},
                  )),
      ),
    );
  }
}
