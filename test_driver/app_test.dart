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
    });

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
    });

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
    });

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
    });
  });
}
