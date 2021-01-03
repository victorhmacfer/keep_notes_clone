import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  // TESTS ASSUME DEVICE HAS INTERNET CONNECTION !
  // All tests must go back to home at the end.
  group('Keep notes clone', () {
    final loginScreenFinder = find.byValueKey('login_screen');
    final loginButtonFinder = find.byValueKey('login_button');
    final loginUsernameFinder = find.byValueKey('login_username');
    final loginPasswordFinder = find.byValueKey('login_pwd');
    final snackBarFinder = find.byType('SnackBar');
    final homeScreenFinder = find.byType('HomeScreen');
    final extendedNoteCardFinder = find.byType('ExtendedNoteCard');
    final smallNoteCardFinder = find.byType('SmallNoteCard');
    final homeDrawerBurgerFinder = find.byValueKey('home_drawer_burger');
    final drawerFinder = find.byValueKey('drawer');
    final remindersDrawerItemFinder = find.byValueKey('reminders_drawer_item');
    final remindersScreenFinder = find.byType('RemindersScreen');
    final remindersScreenBurgerFinder =
        find.byValueKey('reminders_screen_drawer_burger');

    final drawerLabelsEditFinder = find.byValueKey('drawer_labels_edit');

    final archiveDrawerItemFinder = find.byValueKey('archive_drawer_item');
    final archiveScreenFinder = find.byType('ArchiveScreen');
    final archiveScreenBurgerFinder =
        find.byValueKey('archive_screen_drawer_burger');

    final trashDrawerItemFinder = find.byValueKey('trash_drawer_item');
    final trashScreenFinder = find.byType('TrashScreen');
    final trashScreenBurgerFinder =
        find.byValueKey('trash_screen_drawer_burger');

    final notesDrawerItemFinder = find.byValueKey('notes_drawer_item');

    final fabFinder = find.byType('MyCustomFab');

    final noteSetupScreenFinder = find.byType('NoteSetupScreen');
    final noteSetupBackFinder = find.byValueKey('note_setup_back');

    final noteSetupTitleFinder = find.byValueKey('note_setup_title');
    final noteSetupTextFinder = find.byValueKey('note_setup_text');

    final noteSetupArchiveButtonFinder =
        find.byValueKey('note_setup_archive_button');

    final createNewLabelDrawerItemFinder =
        find.byValueKey('create_new_label_drawer_item');

    final editLabelsScreenFinder = find.byType('EditLabelsScreen');

    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('starts logged out, shows login screen', () async {
      await driver.waitFor(loginScreenFinder, timeout: Duration(seconds: 4));
    });

    test(
        'in login screen, login with non existent username, show correct snackbar text',
        () async {
      final snackBarTextFinder = find.text("Username not found");

      await driver.waitFor(loginScreenFinder, timeout: Duration(seconds: 4));

      await driver.tap(loginUsernameFinder);
      await driver.enterText('whateverblabla');
      await driver.tap(loginPasswordFinder);
      await driver.enterText('code123456');
      await driver.tap(loginButtonFinder);

      await driver.waitFor(snackBarFinder);
      await driver.waitFor(snackBarTextFinder);
      await driver.waitForAbsent(snackBarFinder);
    }, skip: true);

    test('in login screen, login with wrong pwd, show correct snackbar text',
        () async {
      final snackBarTextFinder = find.text("Wrong password");

      await driver.waitFor(loginScreenFinder, timeout: Duration(seconds: 4));

      await driver.tap(loginUsernameFinder);
      await driver.enterText('usuarioteste');
      await driver.tap(loginPasswordFinder);
      await driver.enterText('jdioqjewfowhe123');
      await driver.tap(loginButtonFinder);

      await driver.waitFor(snackBarFinder, timeout: Duration(seconds: 10));
      await driver.waitFor(snackBarTextFinder);
      await driver.waitForAbsent(snackBarFinder);
    }, skip: true);

    test(
        'in login screen, login with disabled user, show correct snackbar text',
        () async {
      final snackBarTextFinder = find.text("User disabled");

      await driver.waitFor(loginScreenFinder, timeout: Duration(seconds: 4));

      await driver.tap(loginUsernameFinder);
      await driver.enterText('disableduser');
      await driver.tap(loginPasswordFinder);
      await driver.enterText('whatever123');
      await driver.tap(loginButtonFinder);

      await driver.waitFor(snackBarFinder);
      await driver.waitFor(snackBarTextFinder);
      await driver.waitForAbsent(snackBarFinder);
    }, skip: true);

    test('in login screen, login with good credentials, shows home', () async {
      await driver.waitFor(loginScreenFinder, timeout: Duration(seconds: 4));
      await driver.waitForAbsent(snackBarFinder);

      await driver.tap(loginUsernameFinder);
      await driver.enterText('usuarioteste');
      await driver.tap(loginPasswordFinder);
      await driver.enterText('abc123456');
      await driver.tap(loginButtonFinder);

      await driver.waitForAbsent(snackBarFinder);

      await driver.waitFor(homeScreenFinder, timeout: Duration(seconds: 10));
    });

    test('confirm fresh user has no note or label created', () async {
      await driver.waitFor(homeScreenFinder);
      await driver.waitForAbsent(extendedNoteCardFinder);
      await driver.waitForAbsent(smallNoteCardFinder);

      // reminders screen shows nothing
      await driver.tap(homeDrawerBurgerFinder);
      await driver.waitFor(drawerFinder);
      await driver.tap(remindersDrawerItemFinder);
      await driver.waitFor(remindersScreenFinder);
      await driver.waitForAbsent(extendedNoteCardFinder);
      await driver.waitForAbsent(smallNoteCardFinder);

      // drawer has no label list
      await driver.tap(remindersScreenBurgerFinder);
      await driver.waitFor(drawerFinder);
      await driver.waitForAbsent(drawerLabelsEditFinder); // labels edit

      // archive shows nothing
      await driver.tap(archiveDrawerItemFinder); // archive item
      await driver.waitFor(archiveScreenFinder); // archive screen
      await driver.waitForAbsent(extendedNoteCardFinder);
      await driver.waitForAbsent(smallNoteCardFinder);
      await driver.tap(archiveScreenBurgerFinder);

      // trash shows nothing
      await driver.tap(trashDrawerItemFinder); // trash item
      await driver.waitFor(trashScreenFinder); // trash screen
      await driver.waitForAbsent(extendedNoteCardFinder);
      await driver.waitForAbsent(smallNoteCardFinder);

      // go back to home
      await driver.tap(trashScreenBurgerFinder);
      await driver.tap(notesDrawerItemFinder);
      await driver.waitFor(homeScreenFinder);
    }, skip: true);

    test(
        'back on empty note (no title, text or reminder) will abort creation, shows nothing in home',
        () async {
      // fab
      await driver.tap(fabFinder);
      await driver.waitFor(noteSetupScreenFinder);

      // press back
      await driver.tap(noteSetupBackFinder);

      // in home and finds nothing.
      await driver.waitFor(homeScreenFinder);
      await driver.waitForAbsent(extendedNoteCardFinder);
      await driver.waitForAbsent(smallNoteCardFinder);
    }, skip: true);

    test('delete while creating a note will abort creation', () async {
      // fab
      await driver.tap(fabFinder);
      await driver.waitFor(noteSetupScreenFinder);

      // give it some text
      await driver.tap(noteSetupTextFinder);
      await driver.enterText('some random text');

      // delete it
      await driver.tap(find.byValueKey('note_setup_right_bs_button'));
      await driver.tap(find.byValueKey('right_bs_delete_button'));

      // finds home and does not find text
      await driver.waitFor(homeScreenFinder);
      await driver.waitForAbsent(find.text('some random text'));
    }, skip: true);

    test('create a simple note, shows it', () async {
      // tap fab
      await driver.tap(fabFinder);

      // finds note setup screen
      await driver.waitFor(noteSetupScreenFinder);

      // give it a text and title
      await driver.tap(noteSetupTitleFinder);
      await driver.enterText('first title');
      await driver.tap(noteSetupTextFinder);
      await driver.enterText('first note text');

      // back to home
      await driver.tap(noteSetupBackFinder);

      // finds text content of created note
      await driver.waitFor(find.text('first title'));
      await driver.waitFor(find.text('first note text'));
    });

    //FIXME: hardcoded note data from test above for simplicity.
    test('create another note, shows both', () async {
      await driver.tap(fabFinder);

      await driver.waitFor(noteSetupScreenFinder);

      await driver.tap(noteSetupTitleFinder);
      await driver.enterText('titulo segunda');
      await driver.tap(noteSetupTextFinder);
      await driver.enterText('texto segunda');

      await driver.tap(noteSetupBackFinder);

      await driver.waitFor(find.text('first title'));
      await driver.waitFor(find.text('first note text'));
      await driver.waitFor(find.text('titulo segunda'));
      await driver.waitFor(find.text('texto segunda'));
    });

    test('create pinned', () async {
      await driver.tap(fabFinder);

      await driver.waitFor(noteSetupScreenFinder);

      // tap pin
      await driver.tap(find.byValueKey('note_setup_pin_button'));

      // give it some text
      await driver.tap(noteSetupTitleFinder);
      await driver.enterText('nota pinada');

      // back
      await driver.tap(noteSetupBackFinder);

      // finds 'PINNED' and text in home
      await driver.waitFor(find.text('PINNED'));
      await driver.waitFor(find.text('nota pinada'));
    });

    test('create archived', () async {
      // go to note setup
      await driver.tap(fabFinder);
      await driver.waitFor(noteSetupScreenFinder);

      // type note data
      await driver.tap(noteSetupTextFinder);
      await driver.enterText('texto arquivada');

      // tap archive button
      await driver.tap(noteSetupArchiveButtonFinder);

      // finds home and DOES NOT find note there
      await driver.waitFor(homeScreenFinder);
      await driver.waitForAbsent(find.text('texto arquivada'));

      // go to archive and finds it there
      await driver.tap(homeDrawerBurgerFinder);
      await driver.tap(archiveDrawerItemFinder);
      await driver.waitFor(archiveScreenFinder);
      await driver.waitFor(find.text('texto arquivada'));

      // go back to home
      await driver.tap(archiveScreenBurgerFinder);
      await driver.tap(notesDrawerItemFinder);
      await driver.waitFor(homeScreenFinder);
    });

    test('create label', () async {
      // tap drawer burger
      await driver.tap(homeDrawerBurgerFinder);

      // tap create new label item
      await driver.tap(createNewLabelDrawerItemFinder);

      // finds edit labels screen
      await driver.waitFor(editLabelsScreenFinder);

      // enter text for new label (field starts autofocused)
      await driver.enterText('minha primeira label');

      // tap ok button
      await driver.tap(find.byValueKey('create_label_check_button'));

      // finds label text in list
      await driver.waitFor(find.text('minha primeira label'));

      // tap back button
      await driver.tap(find.pageBack());

      // finds home again
      await driver.waitFor(homeScreenFinder);

      // FIXME: I do this to close drawer so it finds the home drawer burger
      // When I run the app manually this drawer doesnt remain open !!
      // this drag is only needed for the test to work.. wtf
      await driver.scroll(
          find.byType('MyApp'), -300, 0, Duration(milliseconds: 300));
      await driver.waitForAbsent(drawerFinder);

      // finds label in drawer label items
      await driver.tap(homeDrawerBurgerFinder);
      await driver.waitFor(find.text('minha primeira label'));

      // go back to home
      await driver.scroll(
          find.byType('MyApp'), -300, 0, Duration(milliseconds: 300));
      await driver.waitForAbsent(drawerFinder);
    });

    test('create note with existent label', () async {
      // tap home fab
      await driver.tap(fabFinder);
      await driver.waitFor(noteSetupScreenFinder);

      // give it some text
      await driver.tap(noteSetupTextFinder);
      await driver.enterText('nota criada com label');

      // tap right bottom sheet button
      await driver.tap(find.byValueKey('note_setup_right_bs_button'));

      // tap labels button
      await driver.tap(find.byValueKey('right_bs_labels_button'));

      // finds notelabeling screen and the existent label
      await driver.waitFor(find.byType('NoteLabelingScreen'));
      await driver.waitFor(find.text('minha primeira label'));

      // tap checkbox
      await driver.tap(find.byValueKey('checkbox-minha primeira label'));

      // tap back
      await driver.tap(find.pageBack());

      // finds label in chip in note setup
      await driver.waitFor(find.text('minha primeira label'));

      // go back to home
      await driver.tap(noteSetupBackFinder);
      await driver.waitFor(homeScreenFinder);

      // finds note text and label
      await driver.waitFor(find.text('nota criada com label'));
      await driver.waitFor(find.text('minha primeira label'));
    });

    test('create note with new label', () async {
      // fab
      await driver.tap(fabFinder);
      await driver.waitFor(noteSetupScreenFinder);

      // enter note text
      await driver.tap(noteSetupTextFinder);
      await driver.enterText('nota com label nova');

      // tap right bs
      await driver.tap(find.byValueKey('note_setup_right_bs_button'));

      // tap labels
      await driver.tap(find.byValueKey('right_bs_labels_button'));

      // find notelabeling screen and tap "enter label name" textfield
      await driver.waitFor(find.byType('NoteLabelingScreen'));
      await driver.tap(find.byValueKey('note_labeling_name_textfield'));

      // enter name for new label
      await driver.enterText('nova label dentro');

      // tap the create button below
      await driver.tap(find.byValueKey('note_labeling_create_button'));

      // tap back
      await driver.tap(find.pageBack());

      // is in note setup and finds label chip
      await driver.waitFor(noteSetupScreenFinder);
      await driver.waitFor(find.text('nova label dentro'));

      // tap back to home
      await driver.tap(noteSetupBackFinder);

      // finds note text and its label
      await driver.waitFor(find.text('nota com label nova'));
      await driver.waitFor(find.text('nova label dentro'));
    });

    test('create note with reminder - any title or text', () async {
      //fab
      await driver.tap(fabFinder);
      await driver.waitFor(noteSetupScreenFinder);

      // type text
      await driver.tap(noteSetupTextFinder);
      await driver.enterText('nota com reminder e texto');

      // tap reminder button
      await driver.tap(find.byValueKey('note_setup_reminder_button'));

      // finds reminder dialog
      await driver.waitFor(find.byType('ReminderSetupDialog'));

      // tap save
      await driver.tap(find.byValueKey('reminder_dialog_save_button'));

      // finds note setup and chip
      await driver.waitFor(noteSetupScreenFinder);
      await driver.waitFor(find.byType('NoteSetupReminderChip'));

      // back to home
      await driver.tap(noteSetupBackFinder);

      // finds note with text and chip
      await driver.waitFor(find.text('nota com reminder e texto'));
      await driver.waitFor(find.byType('NoteCardReminderChip'));

      // go to reminders screen
      await driver.tap(homeDrawerBurgerFinder);
      await driver.tap(remindersDrawerItemFinder);

      // finds it there
      await driver.waitFor(remindersScreenFinder);
      await driver.waitFor(find.text('nota com reminder e texto'));

      // back to home
      await driver.tap(remindersScreenBurgerFinder);
      await driver.tap(notesDrawerItemFinder);
    });

    test('create note with reminder - just reminder, nothing else', () async {
      //fab
      await driver.tap(fabFinder);
      await driver.waitFor(noteSetupScreenFinder);

      // tap reminder button
      await driver.tap(find.byValueKey('note_setup_reminder_button'));

      // finds reminder dialog
      await driver.waitFor(find.byType('ReminderSetupDialog'));

      // tap save
      await driver.tap(find.byValueKey('reminder_dialog_save_button'));

      // finds note setup and chip
      await driver.waitFor(noteSetupScreenFinder);
      await driver.waitFor(find.byType('NoteSetupReminderChip'));

      // back to home
      await driver.tap(noteSetupBackFinder);

      // finds note with text and chip
      await driver.waitFor(find.text('Empty reminder'));
      await driver.waitFor(find.byType('NoteCardReminderChip'));

      // go to reminders screen
      await driver.tap(homeDrawerBurgerFinder);
      await driver.tap(remindersDrawerItemFinder);

      // finds it there
      await driver.waitFor(remindersScreenFinder);
      await driver.waitFor(find.text('Empty reminder'));

      // back to home
      await driver.tap(remindersScreenBurgerFinder);
      await driver.tap(notesDrawerItemFinder);
    });

    test('change note title and text', () async {
      // tap note
      await driver.tap(find.text('first title'));

      // tap title and enter new text
      await driver.tap(noteSetupTitleFinder);
      await driver.enterText('novo TITULO editado da primeira');

      // tap text and enter new text
      await driver.tap(noteSetupTextFinder);
      await driver.enterText('novo TEXTO editado da primeira');

      // back to home
      await driver.tap(noteSetupBackFinder);
      await driver.waitFor(homeScreenFinder);

      // finds new stuff and not old stuff there
      await driver.waitFor(find.text('novo TITULO editado da primeira'));
      await driver.waitFor(find.text('novo TEXTO editado da primeira'));
      await driver.waitForAbsent(find.text('first title'));
      await driver.waitForAbsent(find.text('first note text'));
    });

    test('unpin the only pinned note', () async {
      // tap pinned note
      await driver.tap(find.text('nota pinada'));

      // tap unpin button and change title
      await driver.tap(find.byValueKey('note_setup_pin_button'));
      await driver.tap(noteSetupTitleFinder);
      await driver.enterText('nota despinada');

      // back
      await driver.tap(noteSetupBackFinder);

      // finds note and does not find 'PINNED' and 'OTHERS' sections
      await driver.waitFor(find.text('nota despinada'));
      await driver.waitForAbsent(find.text('PINNED'));
      await driver.waitForAbsent(find.text('OTHERS'));
    });

    test('archive note', () async {
      // tap note
      await driver.tap(find.text('minha primeira label'));

      // tap archive
      await driver.tap(find.byValueKey('note_setup_archive_button'));

      // finds home, does not find the note
      await driver.waitFor(homeScreenFinder);
      await driver.waitForAbsent(find.text('minha primeira label'));

      // go to archive screen, finds note there
      await driver.tap(homeDrawerBurgerFinder);
      await driver.tap(archiveDrawerItemFinder);
      await driver.waitFor(find.text('minha primeira label'));

      // go back to home
      await driver.tap(archiveScreenBurgerFinder);
      await driver.tap(notesDrawerItemFinder);
      await driver.waitFor(homeScreenFinder);
    });

    test('give note an existent label', () async {
      // tap note
      await driver.tap(find.text('nota despinada'));

      // tap right BS
      await driver.tap(find.byValueKey('note_setup_right_bs_button'));

      // tap labels
      await driver.tap(find.byValueKey('right_bs_labels_button'));

      // tap some existent label to include it..
      await driver.tap(find.text('minha primeira label'));

      // back
      await driver.tap(find.pageBack());

      // finds it in note setup
      await driver.waitFor(find.text('minha primeira label'));
      await driver.waitFor(find.byType('NoteSetupLabelChip'));

      // back
      await driver.tap(noteSetupBackFinder);

      // finds it in home
      await driver.waitFor(find.text('minha primeira label'));
      await driver.waitFor(find.byType('NoteCardLabelChip'));
    });

    test('give note a new label', () async {
      // tap note
      await driver.tap(find.text('texto segunda'));

      // tap right BS
      await driver.tap(find.byValueKey('note_setup_right_bs_button'));

      // tab labels
      await driver.tap(find.byValueKey('right_bs_labels_button'));

      // tap field to get focus
      await driver.tap(find.byValueKey('note_labeling_name_textfield'));

      // enter new label text and create
      await driver.enterText('nova label editando');
      await driver.tap(find.byValueKey('note_labeling_create_button'));

      // back
      await driver.tap(find.pageBack());

      // is in note setup and finds label chip
      await driver.waitFor(noteSetupScreenFinder);
      await driver.waitFor(find.text('nova label editando'));
      await driver.waitFor(find.byType('NoteSetupLabelChip'));

      // tap back to home
      await driver.tap(noteSetupBackFinder);

      // finds note text and its label
      await driver.waitFor(find.text('texto segunda'));
      await driver.waitFor(find.text('nova label editando'));
    });

    test('delete note with reminder from note setup', () async {
      // tap note
      await driver.tap(find.text('nota com reminder e texto'));

      // tap right BS
      await driver.tap(find.byValueKey('note_setup_right_bs_button'));

      // tap delete
      await driver.tap(find.byValueKey('right_bs_delete_button'));

      // does not find it in home
      await driver.waitForAbsent(find.text('nota com reminder e texto'));

      // go to trash
      await driver.tap(homeDrawerBurgerFinder);
      await driver.tap(trashDrawerItemFinder);
      await driver.waitFor(trashScreenFinder);

      // finds text in trash and does not find the reminder chip
      await driver.waitFor(find.text('nota com reminder e texto'));
      await driver.waitForAbsent(find.byType('NoteCardReminderChip'));

      // back to home
      await driver.tap(trashScreenBurgerFinder);
      await driver.tap(notesDrawerItemFinder);
      await driver.waitFor(homeScreenFinder);
    });

    test('give existent note a reminder', () async {
      // tap note
      await driver.tap(find.text('titulo segunda'));

      // tap reminder button
      await driver.tap(find.byValueKey('note_setup_reminder_button'));
      await driver.waitFor(find.byType('ReminderSetupDialog'));

      // tap save
      await driver.tap(find.byValueKey('reminder_dialog_save_button'));

      // finds chip in note setup
      await driver.waitFor(noteSetupScreenFinder);
      await driver.waitFor(find.byType('NoteSetupReminderChip'));

      // back to home
      await driver.tap(noteSetupBackFinder);

      // finds note in home
      // (no point in checking for NoteCardReminderChip in home cuz there were
      //  already some reminder chips there)
      await driver.waitFor(find.text('titulo segunda'));

      // go to reminders screen and finds it there
      await driver.tap(homeDrawerBurgerFinder);
      await driver.tap(remindersDrawerItemFinder);
      await driver.waitFor(remindersScreenFinder);
      await driver.waitFor(find.text('titulo segunda'));

      // back to home
      await driver.tap(remindersScreenBurgerFinder);
      await driver.tap(notesDrawerItemFinder);
    });
  });
}
