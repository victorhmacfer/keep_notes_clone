import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  // TESTS ASSUME DEVICE HAS INTERNET CONNECTION !
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
    }, skip: true);

    test('create a simple note, shows it', () async {
      // go to home
      await driver.tap(trashScreenBurgerFinder);
      await driver.tap(notesDrawerItemFinder);
      await driver.waitFor(homeScreenFinder);

      // tap fab
      await driver.tap(fabFinder);

      // finds note setup screen
      await driver.waitFor(noteSetupScreenFinder);

      // type a note text and title
      await driver.tap(noteSetupTitleFinder);
      final testNoteTitle = 'first title';
      await driver.enterText(testNoteTitle);
      await driver.tap(noteSetupTextFinder);
      final testNoteText = 'first note text';
      await driver.enterText(testNoteText);

      // leave note setup
      await driver.tap(noteSetupBackFinder);

      // finds text content of created note
      await driver.waitFor(find.text(testNoteTitle));
      await driver.waitFor(find.text(testNoteText));
    }, skip: true);

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
    }, skip: true);

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
    }, skip: true);

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

    // test('delete first note, shows everything correctly', () {});

    // test('archive second note, shows everything correctly', () async {});

    // test('create a note with first label, shows correctly', () {});

    // test('remove label from second note, shows note everywhere correctly',
    //     () {});

    // test('delete first label, doesnt show anywhere in the app', () {});
  });
}
