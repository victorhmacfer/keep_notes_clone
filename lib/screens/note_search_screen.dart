import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/note_tracking_bloc.dart';
import 'package:keep_notes_clone/custom_widgets/card_type_section_title.dart';
import 'package:keep_notes_clone/custom_widgets/note_card.dart';
import 'package:keep_notes_clone/custom_widgets/png.dart';
import 'package:keep_notes_clone/models/note.dart';
import 'package:keep_notes_clone/models/search_result.dart';
import 'package:keep_notes_clone/notifiers/note_search_state.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/utils/styles.dart';
import 'package:provider/provider.dart';

var _decorationWithGreyUpperBorder = BoxDecoration(
    color: appWhite, border: Border(top: BorderSide(color: appDividerGrey)));

class NoteSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NoteSearchStateNotifier>(
      create: (context) => NoteSearchStateNotifier(),
      child: Scaffold(
        appBar: _NoteSearchAppBar(),
        body: _BodyPicker(),
      ),
    );
  }
}

class _NoteSearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  //FIXME: depending on framework code..
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      brightness: Brightness.light,
      elevation: 0,
      title: TextField(
        cursorWidth: 1,
        cursorColor: appSettingsBlue,
        decoration: InputDecoration.collapsed(
            hintText: 'Search your notes', hintStyle: searchAppBarStyle),
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

    return (notifier.searching)
        ? _SearchResultsBody()
        : _SearchCategoriesBody();
  }
}

//FIXME: dummy implementation .. will have streambuilder later
class _SearchCategoriesBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: _decorationWithGreyUpperBorder,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _OptionalExpandableGridSection(sectionTitle: 'TYPES', items: [
              _TypeGridItem(
                text: 'Lists',
                pngIconFileName: 'outline_check_box_black_48.png',
              ),
              _TypeGridItem(
                text: 'Images',
                pngIconFileName: 'outline_mic_none_black_48.png',
              ),
              _TypeGridItem(
                text: 'Voice',
                pngIconFileName: 'outline_mic_none_black_48.png',
              ),
              _TypeGridItem(
                text: 'Drawings',
                pngIconFileName: 'outline_mic_none_black_48.png',
              ),
              _TypeGridItem(
                text: 'URLs',
                pngIconFileName: 'outline_mic_none_black_48.png',
              ),
            ]),
            _OptionalExpandableGridSection(sectionTitle: 'LABELS', items: [
              _LabelGridItem(text: 'android-dev'),
              _LabelGridItem(text: 'clean'),
              _LabelGridItem(text: 'compras-vendas'),
              _LabelGridItem(text: 'conseguir estagio'),
              _LabelGridItem(text: 'expenses'),
              _LabelGridItem(text: 'git'),
              _LabelGridItem(text: 'ideas'),
            ]),
            _ColorsGridSection(),
            SizedBox(
              height: 16,
            )
          ],
        ),
      ),
    );
  }
}

class _SearchResultsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var noteBloc = Provider.of<NoteTrackingBloc>(context);

    return Container(
      constraints: BoxConstraints.expand(),
      decoration: _decorationWithGreyUpperBorder,
      child: SingleChildScrollView(
        child: StreamBuilder<SearchResult>(
          stream: noteBloc.noteColorSearchResultStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var regularNotes = snapshot.data.regular;
              var archivedNotes = snapshot.data.archived;
              var deletedNotes = snapshot.data.deleted;

              return Padding(
                padding: EdgeInsets.only(top: 8, bottom: 32),
                child: Column(
                  children: <Widget>[
                    _OptionalSectionColumn(notes: regularNotes),
                    _OptionalSectionColumn(
                        title: 'ARCHIVE', notes: archivedNotes),
                    _OptionalSectionColumn(title: 'TRASH', notes: deletedNotes),
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

Widget _noteCardBuilder(Note note) => NoteCard(note: note);

class _OptionalSectionColumn extends StatelessWidget {
  final String title;

  final List<Note> notes;

  _OptionalSectionColumn({this.title, @required this.notes});

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return Container();
    }

    return Column(
      children: <Widget>[
        (title != null)
            ? CardTypeSectionTitle(title.toUpperCase())
            : Container(),
        Column(children: notes.map(_noteCardBuilder).toList()),
        SizedBox(height: 16),
      ],
    );
  }
}

// FIXME: the grid crossaxis count is hardcoded everywhere as 3.
// this is on purpose.. make this widget more general later !
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
                style: drawerLabelsEditStyle.copyWith(
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

class _ColorsGridSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

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
            style: drawerLabelsEditStyle.copyWith(
                fontSize: 11, letterSpacing: 0.5),
          ),
        ),
        GridView.count(
          padding: EdgeInsets.symmetric(horizontal: 8),
          shrinkWrap: true,
          crossAxisCount: 6,
          physics: NeverScrollableScrollPhysics(),
          children: [
            _ColorCircle(NoteColor.white),
            _ColorCircle(NoteColor.red),
            _ColorCircle(NoteColor.orange),
            _ColorCircle(NoteColor.yellow),
            _ColorCircle(NoteColor.green),
            _ColorCircle(NoteColor.lightBlue),
            _ColorCircle(NoteColor.mediumBlue),
            _ColorCircle(NoteColor.darkBlue),
            _ColorCircle(NoteColor.purple),
            _ColorCircle(NoteColor.pink),
            _ColorCircle(NoteColor.brown),
            _ColorCircle(NoteColor.grey),
          ],
        ),
      ],
    );
  }
}

class _TypeGridItem extends StatelessWidget {
  final String pngIconFileName;

  final String text;

  _TypeGridItem({@required this.pngIconFileName, @required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appSettingsBlue,
      padding: EdgeInsets.symmetric(vertical: 8),
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            height: 1,
          ),
          PngIcon(
            fileName: pngIconFileName,
            size: 32,
            iconColor: appWhite,
          ),
          Text(
            text,
            style: TextStyle(color: appWhite, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _LabelGridItem extends StatelessWidget {
  final String text;

  _LabelGridItem({@required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.symmetric(vertical: 8),
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
            text,
            style: TextStyle(fontSize: 13),
          ),
        ],
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
          style: drawerLabelsEditStyle.copyWith(
              fontSize: 11, letterSpacing: 0.5, color: appSettingsBlue),
        ),
      ),
    );
  }
}

class _ColorCircle extends StatelessWidget {
  final NoteColor noteColor;

  _ColorCircle(this.noteColor);

  @override
  Widget build(BuildContext context) {
    var noteBloc = Provider.of<NoteTrackingBloc>(context);
    var searchNotifier = Provider.of<NoteSearchStateNotifier>(context);

    return FractionallySizedBox(
      widthFactor: 0.75,
      heightFactor: 0.75,
      child: GestureDetector(
        onTap: () {
          noteBloc.searchByNoteColorSink.add(noteColor);
          searchNotifier.searching = true;
        },
        child: Container(
          decoration: BoxDecoration(
              color: noteColor.getColor(),
              border: Border.all(width: 0.5, color: appGreyForColoredBg),
              borderRadius: BorderRadius.circular(40)),
        ),
      ),
    );
  }
}
