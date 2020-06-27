import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _loggedInUserIdBS = BehaviorSubject<String>();

  Stream<String> get loggedInUser => _loggedInUserIdBS.stream;

  AuthBloc() {
    _getLoggedInUser();
  }

  void _getLoggedInUser() async {
    var theUser = await _auth.currentUser();
    if (theUser != null) {
      _loggedInUserIdBS.add(theUser.uid);
    } else {
      _loggedInUserIdBS.add('');
    }
  }


  void login(String email, String pwd) async {
    AuthResult result;

    try {
      result =
          await _auth.signInWithEmailAndPassword(email: email, password: pwd);
    } catch (e) {
      return;
    }
    var theId = result?.user?.uid;

    if (theId != null) {
      _loggedInUserIdBS.add(theId);
    } else {
      _loggedInUserIdBS.add('');
    }
  }

  void dispose() {}
}
