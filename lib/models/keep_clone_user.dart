import 'package:flutter/material.dart';

class KeepCloneUser {
  final String firebaseAuthUID;
  final String username;
  final String email;
  final bool signedOut;

  KeepCloneUser(
      {@required this.firebaseAuthUID,
      @required this.username,
      @required this.email,
      this.signedOut = false});

  factory KeepCloneUser.signedOut() {
    return KeepCloneUser(
        firebaseAuthUID: null, username: null, email: null, signedOut: true);
  }
}
