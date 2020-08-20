import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _loggedInUserIdBS = BehaviorSubject<String>();

  Stream<String> get loggedInUserId => _loggedInUserIdBS.stream;

  AuthBloc() {
    _getLoggedInUser();
  }

  void _getLoggedInUser() {
    var theUser = _auth.currentUser;
    if (theUser != null) {
      _loggedInUserIdBS.add(theUser.uid);
    } else {
      _loggedInUserIdBS.add('');
    }
  }

  void login(String email, String pwd) async {
    UserCredential userCredential;

    try {
      userCredential =
          await _auth.signInWithEmailAndPassword(email: email, password: pwd);
    } catch (e) {
      return;
    }
    var theId = userCredential?.user?.uid;

    if (theId != null) {
      _loggedInUserIdBS.add(theId);
    } else {
      _loggedInUserIdBS.add('');
    }
  }

  void logout() async {
    await _auth.signOut();
    _loggedInUserIdBS.add('');
  }

  void dispose() {}
}
