import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/home_bloc.dart';
import 'package:keep_notes_clone/blocs/label_screen_bloc.dart';
import 'package:keep_notes_clone/custom_widgets/bottom_appbar.dart';
import 'package:keep_notes_clone/custom_widgets/drawer.dart';
import 'package:keep_notes_clone/custom_widgets/floating_action_button.dart';
import 'package:keep_notes_clone/custom_widgets/label_delete_confirmation.dart';
import 'package:keep_notes_clone/custom_widgets/multi_note_selection_appbar.dart';
import 'package:keep_notes_clone/custom_widgets/note_card_grids.dart';
import 'package:keep_notes_clone/custom_widgets/png.dart';
import 'package:keep_notes_clone/home.dart';
import 'package:keep_notes_clone/main.dart';
import 'package:keep_notes_clone/models/label.dart';
import 'package:keep_notes_clone/notifiers/drawer_screen_selection.dart';
import 'package:keep_notes_clone/notifiers/multi_note_selection.dart';
import 'package:keep_notes_clone/notifiers/note_card_mode.dart';
import 'package:keep_notes_clone/screens/no_screen.dart';
import 'package:keep_notes_clone/screens/note_search_screen.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:keep_notes_clone/utils/styles.dart';
import 'package:keep_notes_clone/viewmodels/label_view_model.dart';
import 'package:provider/provider.dart';

class LabelNameNotifier with ChangeNotifier {
  String _labelName;

  LabelNameNotifier(String initialLabelName)
      : assert(initialLabelName.isNotEmpty),
        _labelName = initialLabelName;

  String get labelName => _labelName;

  set labelName(String newName) {
    _labelName = newName;
    notifyListeners();
  }
}

// needs label
class LabelScreen extends StatelessWidget {
  final Label label;

  LabelScreen(this.label);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MultiNoteSelection>(
          create: (context) => MultiNoteSelection(),
        ),
        Provider<LabelScreenBloc>(
            create: (context) => LabelScreenBloc(repo, label)),
        ChangeNotifierProvider<LabelNameNotifier>(
          create: (context) => LabelNameNotifier(label.name),
        ),
      ],
      child: Scaffold(
        backgroundColor: appWhite,
        extendBody: true,
        floatingActionButton: MyCustomFab(label: label),
        floatingActionButtonLocation: MyCustomFabLocation(),
        bottomNavigationBar: MyNotchedBottomAppBar(),
        drawer: MyDrawer(),
        body: _Body(label),
      ),
    );
  }
}

const double _bottomPadding = 56;

enum LabelMenuAction { renameLabel, deleteLabel }

TextEditingController labelRenamingController;
final _formKey = GlobalKey<FormState>();

class _Body extends StatelessWidget {
  final Label label;

  _Body(this.label) {
    labelRenamingController = TextEditingController(text: label.name);
  }

  @override
  Widget build(BuildContext context) {
    var noteCardModeNotifier = Provider.of<NoteCardModeSelection>(context);
    var labelScreenBloc = Provider.of<LabelScreenBloc>(context);
    var drawerScreenSelection = Provider.of<DrawerScreenSelection>(context);

    var multiNoteSelection = Provider.of<MultiNoteSelection>(context);

    return SafeArea(
        bottom: false,
        child: Container(
          child: CustomScrollView(
            slivers: <Widget>[
              (multiNoteSelection.inactive)
                  ? _LabelAppBar(
                      bloc: labelScreenBloc,
                      cardModeNotifier: noteCardModeNotifier,
                      drawerScreenSelection: drawerScreenSelection)
                  : SliverMultiNoteSelectionAppBar(
                      notifier: multiNoteSelection,
                      noteChangerBloc: labelScreenBloc,
                    ),
              SliverToBoxAdapter(
                child: _StreamBuilderBody(),
              ),
            ],
          ),
        ));
  }
}

class _SelectNoteCardModeButton extends StatelessWidget {
  final NoteCardModeSelection noteCardModeSelector;

  _SelectNoteCardModeButton(this.noteCardModeSelector);

  @override
  Widget build(BuildContext context) {
    if (noteCardModeSelector.mode == NoteCardMode.extended) {
      return PngIconButton(
          backgroundColor: appWhite,
          padding: EdgeInsets.symmetric(horizontal: 8),
          pngIcon: PngIcon(
            fileName: 'outline_dashboard_black_48.png',
          ),
          onTap: () {
            noteCardModeSelector.switchTo(NoteCardMode.small);
          });
    }
    return PngIconButton(
        backgroundColor: appWhite,
        padding: EdgeInsets.symmetric(horizontal: 8),
        pngIcon: PngIcon(
          fileName: 'outline_view_agenda_black_48.png',
        ),
        onTap: () {
          noteCardModeSelector.switchTo(NoteCardMode.extended);
        });
  }
}

class _StreamBuilderBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var labelScreenBloc = Provider.of<LabelScreenBloc>(context);
    var modeNotifier = Provider.of<NoteCardModeSelection>(context);

    return StreamBuilder<LabelViewModel>(
        stream: labelScreenBloc.labelViewModelStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var pinnedNotes = snapshot.data.pinned;
            var unpinnedNotes = snapshot.data.unpinned;
            var archivedNotes = snapshot.data.archived;

            var hasAnyNote = pinnedNotes.isNotEmpty ||
                unpinnedNotes.isNotEmpty ||
                archivedNotes.isNotEmpty;

            var onlyHasUnpinnedNotes =
                hasAnyNote && (pinnedNotes.isEmpty && archivedNotes.isEmpty);

            if (hasAnyNote) {
              if (onlyHasUnpinnedNotes) {
                return Container(
                  margin: EdgeInsets.only(bottom: _bottomPadding),
                  child: DismissibleOptionalSection(
                    bloc: labelScreenBloc,
                    mode: modeNotifier.mode,
                    noSpacer: true,
                    notes: unpinnedNotes,
                  ),
                );
              }
              return Container(
                margin: EdgeInsets.only(bottom: _bottomPadding),
                child: Column(
                  children: <Widget>[
                    DismissibleOptionalSection(
                      bloc: labelScreenBloc,
                      title: 'PINNED',
                      mode: modeNotifier.mode,
                      spaceBelow: true,
                      notes: pinnedNotes,
                    ),
                    DismissibleOptionalSection(
                      bloc: labelScreenBloc,
                      title: 'OTHERS',
                      mode: modeNotifier.mode,
                      spaceBelow: true,
                      notes: unpinnedNotes,
                    ),
                    OptionalSection(
                      title: 'ARCHIVED',
                      mode: modeNotifier.mode,
                      notes: archivedNotes,
                      noSpacer: true,
                    ),
                  ],
                ),
              );
            }
            return NoLabelsScreen();
          }
          return Container();
        });
  }
}

class LabelRenameDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var labelScreenBloc = Provider.of<LabelScreenBloc>(context);

    var labelNameNotifier = Provider.of<LabelNameNotifier>(context);

    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      title: Text('Rename label'),
      titleTextStyle: cardTitleStyle,
      content: SizedBox(
        width: screenWidth * 0.7,
        child: Form(
          key: _formKey,
          child: TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Label name cannot be empty';
              }

              if (labelScreenBloc.renameLabel(value) == false) {
                return 'This label name is already in use';
              }
              return null;
            },
            controller: labelRenamingController,
            textAlignVertical: TextAlignVertical.center,
            autofocus: true,
            cursorColor: NoteColor.orange.getColor(),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 4),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: appDividerGrey, width: 2)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: appDividerGrey, width: 2)),
              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2)),
            ),
          ),
        ),
      ),
      titlePadding: EdgeInsets.fromLTRB(24, 16, 24, 0),
      contentPadding: EdgeInsets.fromLTRB(24, 0, 24, 16),
      actionsPadding: EdgeInsets.fromLTRB(0, 16, 4, 0),
      buttonPadding: EdgeInsets.symmetric(horizontal: 8),
      actions: <Widget>[
        FlatButton(
          key: ValueKey('label_screen_dialog_cancel_button'),
          color: appWhite,
          onPressed: () {
            labelRenamingController.text = labelNameNotifier.labelName;
            Navigator.pop(context);
          },
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Cancel',
            style: cardTitleStyle.copyWith(fontSize: 14),
          ),
        ),
        FlatButton(
          key: ValueKey('label_screen_dialog_rename_button'),
          color: NoteColor.orange.getColor(),
          padding: EdgeInsets.symmetric(horizontal: 16),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              Navigator.pop<String>(context, labelRenamingController.text);
            }
          },
          child: Text(
            'Rename',
            style: cardTitleStyle.copyWith(fontSize: 14),
          ),
        ),
      ],
    );
  }
}

class _LabelAppBar extends StatelessWidget {
  final LabelScreenBloc bloc;
  final NoteCardModeSelection cardModeNotifier;
  final DrawerScreenSelection drawerScreenSelection;

  _LabelAppBar(
      {@required this.bloc,
      @required this.cardModeNotifier,
      @required this.drawerScreenSelection});

  @override
  Widget build(BuildContext context) {
    var labelNameNotifier = Provider.of<LabelNameNotifier>(context);

    return SliverAppBar(
      leading: IconButton(
        key: ValueKey('label_screen_drawer_burger'),
        icon: Icon(
          Icons.menu,
          color: appIconGrey,
        ),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      floating: true,
      backgroundColor: appWhite,
      iconTheme: IconThemeData(color: appIconGrey),
      title: Text(
        labelNameNotifier.labelName,
        key: ValueKey('label_screen_appbar_label_name'),
        style: drawerItemStyle(mqScreenSize.width).copyWith(fontSize: 18, letterSpacing: 0),
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 4),
          child: PngIconButton(
              backgroundColor: appWhite,
              padding: EdgeInsets.symmetric(horizontal: 8),
              pngIcon: PngIcon(fileName: 'baseline_search_black_48.png'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NoteSearchScreen()));
              }),
        ),
        _SelectNoteCardModeButton(cardModeNotifier),
        PopupMenuButton<LabelMenuAction>(
          key: ValueKey('label_screen_menu_button'),
          onSelected: (action) async {
            if (action == LabelMenuAction.renameLabel) {
              var newName = await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => MultiProvider(
                        providers: [
                          Provider<LabelScreenBloc>.value(value: bloc),
                          ChangeNotifierProvider.value(
                              value: labelNameNotifier),
                        ],
                        child: LabelRenameDialog(),
                      ));

              if (newName?.isNotEmpty ?? false) {
                labelNameNotifier.labelName = newName;
              }
            } else if (action == LabelMenuAction.deleteLabel) {
              var shouldDelete = await showDialog<bool>(
                barrierDismissible:
                    true, // "shouldDelete" might be null as well.
                context: context,
                builder: (context) => LabelDeleteConfirmationDialog(),
              );
              if (shouldDelete) {
                drawerScreenSelection.changeSelectedScreenToIndex(0);

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Provider<HomeBloc>(
                              create: (context) => HomeBloc(repo),
                              child: HomeScreen(),
                            )));

                bloc.deleteLabel();
              }
            }
          },
          icon: Icon(Icons.more_vert),
          itemBuilder: (context) => <PopupMenuEntry<LabelMenuAction>>[
            PopupMenuItem<LabelMenuAction>(
              key: ValueKey('label_screen_menu_item_rename'),
              value: LabelMenuAction.renameLabel,
              child: Text('Rename label'),
            ),
            PopupMenuItem<LabelMenuAction>(
              key: ValueKey('label_screen_menu_item_delete'),
              value: LabelMenuAction.deleteLabel,
              child: Text('Delete label'),
            ),
          ],
        ),
      ],
    );
  }
}
