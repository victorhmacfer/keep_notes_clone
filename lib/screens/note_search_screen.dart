import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/search_bloc.dart';
import 'package:keep_notes_clone/custom_widgets/multi_note_selection_appbar.dart';
import 'package:keep_notes_clone/custom_widgets/note_card_grids.dart';
import 'package:keep_notes_clone/custom_widgets/png.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/notifiers/multi_note_selection.dart';
import 'package:keep_notes_clone/notifiers/note_card_mode.dart';
import 'package:keep_notes_clone/notifiers/note_search_state.dart';
import 'package:keep_notes_clone/screens/no_screen.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/utils/styles.dart';
import 'package:keep_notes_clone/viewmodels/search_landing_page_view_model.dart';
import 'package:keep_notes_clone/viewmodels/search_request_view_model.dart';
import 'package:keep_notes_clone/viewmodels/search_result_view_model.dart';
import 'package:provider/provider.dart';

import 'package:keep_notes_clone/main.dart';

var _decorationWithGreyUpperBorder = BoxDecoration(
    color: appWhite, border: Border(top: BorderSide(color: appDividerGrey)));

class NoteSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NoteSearchStateNotifier>(
          create: (context) => NoteSearchStateNotifier(),
        ),
        ChangeNotifierProvider<MultiNoteSelection>(
          create: (context) => MultiNoteSelection(),
        ),
        Provider<SearchBloc>(
          create: (context) => SearchBloc(repo),
        ),
      ],
      child: _SearchScaffold(),
    );
  }
}

class _SearchScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var multiNoteSelection = Provider.of<MultiNoteSelection>(context);
    var searchBloc = Provider.of<SearchBloc>(context);

    return Scaffold(
      appBar: (multiNoteSelection.inactive)
          ? _NoteSearchAppBar()
          : BoxMultiNoteSelectionAppBar(
              notifier: multiNoteSelection,
              noteChangerBloc: searchBloc,
            ),
      body: _BodyPicker(),
    );
  }
}

class _NoteSearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    var searchBloc = Provider.of<SearchBloc>(context);
    var notifier = Provider.of<NoteSearchStateNotifier>(context);

    var hintText = (notifier.showingResult)
        ? 'Search within "${notifier.resultCategory}"'
        : 'Search your notes';

    return AppBar(
      leading: IconButton(
        key: ValueKey('note_search_back'),
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      brightness: Brightness.light,
      elevation: 0,
      title: TextField(
        autofocus: true,
        controller: notifier.searchController,
        onChanged: (value) {
          if (notifier.tryFullClear(value)) {
            return;
          }
          notifier.showingResult = true;
          searchBloc.searchNotesWithSubstring(
              value, notifier.lastResultViewModel);
        },
        cursorWidth: 1,
        cursorColor: appSettingsBlue,
        decoration: InputDecoration.collapsed(
            hintText: hintText,
            hintStyle: searchAppBarStyle(mqScreenSize.width)),
      ),
      iconTheme: IconThemeData(color: appIconGrey),
      backgroundColor: appWhite,
    );
  }
}

class _BodyPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var notifier = Provider.of<NoteSearchStateNotifier>(context);

    return (notifier.showingResult)
        ? _SearchResultBody()
        : _SearchLandingPageBody();
  }
}

class _SearchLandingPageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var searchBloc = Provider.of<SearchBloc>(context);

    return Container(
      constraints: BoxConstraints.expand(),
      decoration: _decorationWithGreyUpperBorder,
      child: StreamBuilder<SearchLandingPageViewModel>(
          stream: searchBloc.searchLandingPageViewModelStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _OptionalExpandableGridSection(
                        sectionTitle: 'LABELS',
                        items: snapshot.data.sortedLabelsInUse
                            .map((lab) => NoteSearchLabelItem(label: lab))
                            .toList()),
                    _OptionalColorsGridSection(
                        items: snapshot.data.noteColorsInUse),
                    SizedBox(
                      height: 16,
                    )
                  ],
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}

class _SearchResultBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var searchBloc = Provider.of<SearchBloc>(context);
    var searchStateNotifier = Provider.of<NoteSearchStateNotifier>(context);
    var modeNotifier = Provider.of<NoteCardModeSelection>(context);

    return Container(
      constraints: BoxConstraints.expand(),
      decoration: _decorationWithGreyUpperBorder,
      child: SingleChildScrollView(
        child: StreamBuilder<SearchResultViewModel>(
          stream: searchBloc.searchResultViewModelStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var regularNotes = snapshot.data.regular;
              var archivedNotes = snapshot.data.archived;
              var deletedNotes = snapshot.data.deleted;

              searchStateNotifier.lastResultViewModel = snapshot.data;

              if (snapshot.data.isEmpty) {
                return NoSearchResultScreen();
              }

              return Padding(
                padding: EdgeInsets.only(top: 8),
                child: Column(
                  children: <Widget>[
                    OptionalSection(
                      mode: modeNotifier.mode,
                      notes: regularNotes,
                      spaceBelow: true,
                    ),
                    OptionalSection(
                      title: 'ARCHIVE',
                      mode: modeNotifier.mode,
                      notes: archivedNotes,
                      spaceBelow: true,
                    ),
                    OptionalSection(
                      title: 'TRASH',
                      mode: modeNotifier.mode,
                      notes: deletedNotes,
                      spaceBelow: true,
                    ),
                  ],
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

// FIXME: the grid crossaxis count is hardcoded everywhere as 3.
// this was on purpose.. make this widget more general later !
class _OptionalExpandableGridSection extends StatefulWidget {
  final String sectionTitle;

  final List<Widget> items;

  _OptionalExpandableGridSection(
      {@required this.sectionTitle, @required this.items});

  @override
  _OptionalExpandableGridSectionState createState() =>
      _OptionalExpandableGridSectionState();
}

class _OptionalExpandableGridSectionState
    extends State<_OptionalExpandableGridSection> {
  bool expanded;

  @override
  void initState() {
    super.initState();
    expanded = false;
  }

  List<Widget> _gridChildren() {
    if ((widget.items.length > 3) && !expanded) {
      return widget.items.getRange(0, 3).toList();
    }
    return widget.items;
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    var moreLessButtonIsVisible = widget.items.length > 3;

    if (widget.items.isEmpty) {
      return Container();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          color: appWhite,
          height: 40,
          width: screenWidth,
          padding: EdgeInsets.only(left: 16, right: 8),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                widget.sectionTitle,
                style: drawerLabelsEditStyle(mqScreenSize.width).copyWith(
                    fontSize: 11, letterSpacing: 0.5),
              ),
              (moreLessButtonIsVisible)
                  ? _MoreLessFlatButton(expanded, onTap: () {
                      setState(() {
                        expanded = !expanded;
                      });
                    })
                  : Container(),
            ],
          ),
        ),
        GridView.count(
            shrinkWrap: true,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            crossAxisCount: 3,
            physics: NeverScrollableScrollPhysics(),
            children: _gridChildren()),
      ],
    );
  }
}

class _OptionalColorsGridSection extends StatelessWidget {
  final List<NoteColor> items;

  _OptionalColorsGridSection({@required this.items});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    if (items.isEmpty) {
      return Container();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          color: appWhite,
          height: 40,
          width: screenWidth,
          padding: EdgeInsets.only(left: 16),
          alignment: Alignment.centerLeft,
          child: Text(
            'COLORS',
            style: drawerLabelsEditStyle(mqScreenSize.width).copyWith(
                fontSize: 11, letterSpacing: 0.5),
          ),
        ),
        GridView.count(
          padding: EdgeInsets.symmetric(horizontal: 8),
          shrinkWrap: true,
          crossAxisCount: 6,
          physics: NeverScrollableScrollPhysics(),
          children: items
              .map((noteColor) => NoteSearchColorCircle(noteColor))
              .toList(),
        ),
      ],
    );
  }
}

// class _TypeGridItem extends StatelessWidget {
//   final String pngIconFileName;

//   final String text;

//   _TypeGridItem({@required this.pngIconFileName, @required this.text});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: appSettingsBlue,
//       padding: EdgeInsets.symmetric(vertical: 8),
//       alignment: Alignment.bottomCenter,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           SizedBox(
//             height: 1,
//           ),
//           PngIcon(
//             fileName: pngIconFileName,
//             size: 32,
//             iconColor: appWhite,
//           ),
//           Text(
//             text,
//             style: TextStyle(color: appWhite, fontSize: 13),
//           ),
//         ],
//       ),
//     );
//   }
// }

class NoteSearchLabelItem extends StatelessWidget {
  final Label label;

  NoteSearchLabelItem({@required this.label});

  @override
  Widget build(BuildContext context) {
    var searchBloc = Provider.of<SearchBloc>(context);
    var searchNotifier = Provider.of<NoteSearchStateNotifier>(context);

    return GestureDetector(
      onTap: () {
        searchBloc.searchRequestSink.add(LabelSearchRequestViewModel(label));
        searchNotifier.setResultCategoryFromLabel(label);
        searchNotifier.showingResult = true;
      },
      child: Container(
        color: Colors.grey[100],
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              height: 1,
            ),
            PngIcon(
              fileName: 'outline_label_black_48.png',
              size: 38,
              iconColor: Color.fromARGB(255, 136, 136, 136),
            ),
            Text(
              label.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoreLessFlatButton extends StatelessWidget {
  final void Function() onTap;

  final bool expanded;

  _MoreLessFlatButton(this.expanded, {@required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        color: appWhite,
        child: Text(
          (expanded) ? 'LESS' : 'MORE',
          style: drawerLabelsEditStyle(mqScreenSize.width).copyWith(
              fontSize: 11, letterSpacing: 0.5, color: appSettingsBlue),
        ),
      ),
    );
  }
}

class NoteSearchColorCircle extends StatelessWidget {
  final NoteColor noteColor;

  NoteSearchColorCircle(this.noteColor);

  @override
  Widget build(BuildContext context) {
    var noteBloc = Provider.of<SearchBloc>(context);
    var searchNotifier = Provider.of<NoteSearchStateNotifier>(context);

    return FractionallySizedBox(
      widthFactor: 0.75,
      heightFactor: 0.75,
      child: GestureDetector(
        onTap: () {
          noteBloc.searchRequestSink
              .add(NoteColorSearchRequestViewModel(noteColor));
          searchNotifier.setResultCategoryFromNoteColor(noteColor);
          searchNotifier.showingResult = true;
        },
        child: Container(
          key: ValueKey(
              'note_search_color_circle_${noteColor.colorDescription}'),
          decoration: BoxDecoration(
              color: noteColor.getColor(),
              border: Border.all(width: 0.5, color: appGreyForColoredBg),
              borderRadius: BorderRadius.circular(40)),
        ),
      ),
    );
  }
}
