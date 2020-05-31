import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/note_tracking_bloc.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/styles.dart';
import 'package:provider/provider.dart';

import 'colors.dart';

class EditLabelsScreen extends StatelessWidget {
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
            SliverToBoxAdapter(child: LabelSearchBar()),
            SliverToBoxAdapter(
              child: StreamBuilder<List<Label>>(
                  stream: noteTrackingBloc.labelListStream,
                  builder: (context, snapshot) {
                    return Container();
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class LabelSearchBar extends StatefulWidget {
  @override
  _LabelSearchBarState createState() => _LabelSearchBarState();
}

class _LabelSearchBarState extends State<LabelSearchBar> {
  final searchFocusNode = FocusNode();

  bool isFocused;

  TextEditingController searchTextController;

  @override
  void initState() {
    super.initState();
    isFocused = true;
    searchTextController = TextEditingController();
    searchFocusNode.addListener(() {
      setState(() {
        isFocused = searchFocusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var fakeBorderColor = (isFocused) ? appDividerGrey : appWhite;

    var myPrefixIconChoice = (isFocused)
        ? Icon(
            Icons.clear,
            color: appIconGrey,
            size: 24,
          )
        : Icon(
            Icons.add,
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
      height: 56,
      padding: EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: appWhite,
        border: Border.symmetric(
            vertical: BorderSide(color: fakeBorderColor, width: 1)),
      ),
      child: TextField(
        cursorColor: appIconGrey,
        cursorWidth: 1,
        style: drawerItemStyle,
        focusNode: searchFocusNode,
        autofocus: true,
        decoration: InputDecoration(
            prefixIcon: paddedPrefixIcon,
            border: InputBorder.none,
            hintStyle: TextStyle(
                fontSize: 15, color: Color.fromARGB(255, 198, 198, 198)),
            hintText: 'Create new label',
            suffixIcon: (isFocused)
                ? Icon(
                    Icons.check,
                    color: appIconGrey,
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
