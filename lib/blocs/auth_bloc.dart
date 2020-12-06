import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:keep_notes_clone/models/keep_clone_user.dart';
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

  final _loggedInUserBS = BehaviorSubject<KeepCloneUser>();

  Stream<KeepCloneUser> get loggedInUser => _loggedInUserBS.stream;

  final _connectivityChecker = Connectivity();

  AuthBloc() {
    _auth.authStateChanges().listen((firebaseAuthUser) async {
      String firebaseAuthUid = firebaseAuthUser?.uid;
      if (firebaseAuthUid == null) {
        _loggedInUserBS.add(KeepCloneUser.signedOut());
      } else {
        var queryDocumentSnapshot = (await _firebaseFirestore
                .collection("users")
                .where('firebaseAuthUid', isEqualTo: firebaseAuthUid)
                .get())
            .docs
            .first;

        String username = queryDocumentSnapshot.id;
        String email = queryDocumentSnapshot.data()['email'];
        _loggedInUserBS.add(KeepCloneUser(
            firebaseAuthUID: firebaseAuthUid,
            username: username,
            email: email));
      }
    });
  }

  Future<LoginError> login(String username, String pwd) async {
    if ((await _hasInternetConnection()) == false) {
      return LoginError.authenticationUnavailable;
    }

    var docSnapshot =
        await _firebaseFirestore.collection("users").doc(username).get();

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
        await _firebaseFirestore.collection("users").doc(username).get();

    if (docSnapshot.exists) {
      return SignUpError.usernameAlreadyInUse;
    }

    UserCredential userCredential;

    try {
      userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: pwd);
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

    var firebaseAuthUid = userCredential?.user?.uid;

    if (firebaseAuthUid == null) {
      return SignUpError.unknown;
    }
    // TODO: WHAT ARE THE POSSIBLE ERRORS HERE ?
    await _firebaseFirestore
        .collection("users")
        .doc(username)
        .set({'firebaseAuthUid': firebaseAuthUid, 'email': email});

    return SignUpError.none;
  }

  // should call this at the start every method that uses the internet
  Future<bool> _hasInternetConnection() async {
    var cr = await _connectivityChecker.checkConnectivity();
    return !(cr == ConnectivityResult.none);
  }

  void logout() {
    _auth.signOut();
    repo = null; // FIXME: this is wrong.
  }

  void dispose() {}
}
