import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/edit_labels_bloc.dart';
import 'package:keep_notes_clone/custom_widgets/label_delete_confirmation.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/utils/styles.dart';
import 'package:provider/provider.dart';

import 'package:keep_notes_clone/utils/colors.dart';

import 'package:keep_notes_clone/main.dart';

class EditLabelsScreen extends StatelessWidget {
  final bool autoFocus;

  EditLabelsScreen({@required this.autoFocus});

  @override
  Widget build(BuildContext context) {
    return Provider<EditLabelsBloc>(
      create: (context) => EditLabelsBloc(repo),
      child: _EditLabelsScreen(autoFocus: autoFocus),
    );
  }
}

class _EditLabelsScreen extends StatelessWidget {
  final bool autoFocus;

  _EditLabelsScreen({@required this.autoFocus});

  List<Widget> _labelList(List<Label> labels) {
    return labels
        .map((label) => _EditLabelListItem(
              label: label,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    var editLabelsBloc = Provider.of<EditLabelsBloc>(context);

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
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
            SliverToBoxAdapter(
                child: _CreateLabelListItem(
              autoFocus: autoFocus,
            )),
            SliverToBoxAdapter(
              child: StreamBuilder<List<Label>>(
                  stream: editLabelsBloc.sortedLabelsStream,
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

class _CreateLabelListItem extends StatefulWidget {
  final bool autoFocus;

  _CreateLabelListItem({@required this.autoFocus});

  @override
  _CreateLabelListItemState createState() => _CreateLabelListItemState();
}

class _CreateLabelListItemState extends State<_CreateLabelListItem> {
  final newLabelFocusNode = FocusNode();

  bool isFocused;

  TextEditingController newLabelTextController;

  @override
  void initState() {
    super.initState();
    isFocused = widget.autoFocus;
    newLabelTextController = TextEditingController();
    newLabelFocusNode.addListener(() {
      setState(() {
        isFocused = newLabelFocusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var editLabelsBloc = Provider.of<EditLabelsBloc>(context);

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
        autofocus: widget.autoFocus,
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
                        editLabelsBloc
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

class _EditLabelListItem extends StatefulWidget {
  final Label label;

  _EditLabelListItem({@required this.label}) : super(key: ValueKey(label.id));

  @override
  _EditLabelListItemState createState() => _EditLabelListItemState();
}

class _EditLabelListItemState extends State<_EditLabelListItem> {
  final itemFocusNode = FocusNode();

  bool isFocused;

  TextEditingController itemTextController;

  @override
  void initState() {
    super.initState();
    isFocused = false;
    itemTextController = TextEditingController(text: widget.label.name);
    itemFocusNode.addListener(() {
      setState(() {
        isFocused = itemFocusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var editLabelsBloc = Provider.of<EditLabelsBloc>(context);

    var fakeBorderColor = (isFocused) ? appDividerGrey : appWhite;

    Widget myPrefixIconButtonChoice = (isFocused)
        ? IconButton(
            onPressed: () async {
              var shouldDelete = await showDialog<bool>(
                barrierDismissible:
                    true, // "shouldDelete" might be null as well.
                context: context,
                builder: deleteConfirmationDialog,
              );
              if (shouldDelete) {
                editLabelsBloc.onDeleteLabel(widget.label);
              }
            },
            icon: Icon(
              Icons.delete_outline,
              size: 24,
            ),
            color: appIconGrey,
          )
        : Icon(
            Icons.label_outline,
            color: appIconGrey,
            size: 24,
          );

    var paddedPrefixIcon = Container(
      color: appWhite,
      height: 2,
      width: 52,
      margin: EdgeInsets.only(right: 16),
      child: myPrefixIconButtonChoice,
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
                    onPressed: () {
                      editLabelsBloc.renameLabel(
                          widget.label, itemTextController.text);
                      itemFocusNode.unfocus();
                    },
                  )
                : Icon(
                    Icons.create,
                    color: appIconGrey,
                  )),
      ),
    );
  }
}
