import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/auth_bloc.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final pwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context);
    print('queota');

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Colors.purple[100],
        child: Center(
          child: SizedBox(
            width: 300,
            height: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Login',
                  style: TextStyle(fontSize: 36),
                ),
                TextField(
                  controller: emailController,
                ),
                TextField(
                  controller: pwdController,
                ),
                RaisedButton(
                  child: Text('Login'),
                  onPressed: () {
                    var theEmail = emailController.text;
                    var thePwd = pwdController.text;

                    authBloc.login(theEmail, thePwd);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
