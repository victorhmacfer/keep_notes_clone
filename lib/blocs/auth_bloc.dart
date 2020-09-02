import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:keep_notes_clone/main.dart';

enum LoginError {
  none,
  usernameNotFound,
  wrongPwd,
  userDisabled,
  invalidEmail,
  emailNotFound,
  authenticationUnavailable,
  unknown,
}

enum SignUpError {
  none,
  authenticationUnavailable,
  usernameAlreadyInUse,
  emailAlreadyInUse,
  invalidEmail,
  emailAccountsDisabled,
  weakPassword,
  unknown,
}

class AuthBloc {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final _loggedInUserIdBS = BehaviorSubject<String>();

  Stream<String> get loggedInUserId => _loggedInUserIdBS.stream;

  final _connectivityChecker = Connectivity();

  AuthBloc() {
    _auth.authStateChanges().listen((user) {
      String userId = user?.uid ?? '';
      _loggedInUserIdBS.add(userId);
    });
  }

  Future<LoginError> login(String username, String pwd) async {
    if ((await _hasInternetConnection()) == false) {
      return LoginError.authenticationUnavailable;
    }

    var docSnapshot =
        await _firebaseFirestore.collection("usernames").doc(username).get();

    if (docSnapshot.exists == false) {
      return LoginError.usernameNotFound;
    }

    String email = docSnapshot.data()['email'];
    UserCredential userCredential;

    try {
      userCredential =
          await _auth.signInWithEmailAndPassword(email: email, password: pwd);
    } on Exception catch (e) {
      if (e.toString().contains('wrong-password')) {
        return LoginError.wrongPwd;
      } else if (e.toString().contains('invalid-email')) {
        return LoginError.invalidEmail;
      } else if (e.toString().contains('user-disabled')) {
        return LoginError.userDisabled;
      } else if (e.toString().contains('user-not-found')) {
        return LoginError.emailNotFound;
      } else {
        return LoginError.unknown;
      }
    } catch (error) {
      return LoginError.unknown;
    }
    var theId = userCredential?.user?.uid;

    if (theId == null) {
      return LoginError.unknown;
    }
    return LoginError.none; // FIXME: is this necessary ?
  }

  Future<SignUpError> signup(String username, String email, String pwd) async {
    if ((await _hasInternetConnection()) == false) {
      return SignUpError.authenticationUnavailable;
    }

    var docSnapshot =
        await _firebaseFirestore.collection("usernames").doc(username).get();

    if (docSnapshot.exists) {
      return SignUpError.usernameAlreadyInUse;
    }

    // TODO: WHAT ARE THE POSSIBLE ERRORS HERE ?
    await _firebaseFirestore
        .collection("usernames")
        .doc(username)
        .set({'email': email});

    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: pwd);
    } on Exception catch (e) {
      if (e.toString().contains('email-already-in-use')) {
        return SignUpError.emailAlreadyInUse;
      } else if (e.toString().contains('invalid-email')) {
        return SignUpError.invalidEmail;
      } else if (e.toString().contains('weak-password')) {
        return SignUpError.weakPassword;
      } else if (e.toString().contains('operation-not-allowed')) {
        return SignUpError.emailAccountsDisabled;
      }
    } catch (error) {
      return SignUpError.unknown;
    }

    // TODO: WHAT ARE THE POSSIBLE ERRORS HERE ?
    await _firebaseFirestore
        .collection("usernames")
        .doc(username)
        .set({'email': email});

    return SignUpError.none;
  }

  // should call this at the start every method that uses the internet
  Future<bool> _hasInternetConnection() async {
    var cr = await _connectivityChecker.checkConnectivity();
    return !(cr == ConnectivityResult.none);
  }

  void logout() {
    _auth.signOut();
    globalNoteRepo = null; // FIXME: this is wrong.
  }

  void dispose() {}
}
