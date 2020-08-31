import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:keep_notes_clone/main.dart';

enum LoginError {
  none,
  usernameNotFoundError,
  wrongPwdError,
  userDisabledError,
  invalidEmailError,
  emailNotFoundError,
  authenticationUnavailableError,
  unknownError,
}

class AuthBloc {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final _loggedInUserIdBS = BehaviorSubject<String>();

  Stream<String> get loggedInUserId => _loggedInUserIdBS.stream;

  final _connectivityChecker = Connectivity();

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

  Future<LoginError> login(String username, String pwd) async {
    if ((await _hasInternetConnection()) == false) {
      return LoginError.authenticationUnavailableError;
    }

    var docSnapshot =
        await _firebaseFirestore.collection("usernames").doc(username).get();

    if (docSnapshot.exists == false) {
      return LoginError.usernameNotFoundError;
    }

    String email = docSnapshot.data()['email'];
    UserCredential userCredential;

    try {
      userCredential =
          await _auth.signInWithEmailAndPassword(email: email, password: pwd);
    } on Exception catch (e) {
      print('entrei no catch caralho');
      print('a exception eh.. $e');

      if (e.toString().contains('wrong-password')) {
        return LoginError.wrongPwdError;
      } else if (e.toString().contains('invalid-email')) {
        return LoginError.invalidEmailError;
      } else if (e.toString().contains('user-disabled')) {
        return LoginError.userDisabledError;
      } else if (e.toString().contains('user-not-found')) {
        return LoginError.emailNotFoundError;
      } else {
        return LoginError.unknownError;
      }
    } catch (error) {
      return LoginError.unknownError;
    }
    var theId = userCredential?.user?.uid;

    if (theId == null) {
      return LoginError.unknownError;
    }
    _loggedInUserIdBS.add(theId);
    return LoginError.none; // FIXME: is this necessary ?
  }

  // should call this at the start every method that uses the internet
  Future<bool> _hasInternetConnection() async {
    var cr = await _connectivityChecker.checkConnectivity();
    return !(cr == ConnectivityResult.none);
  }

  void logout() {
    _auth.signOut();
    _loggedInUserIdBS.add('');
    globalNoteRepo = null; // FIXME: this is wrong.
  }

  void dispose() {}
}
