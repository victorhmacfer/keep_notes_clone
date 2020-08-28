import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/auth_bloc.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:provider/provider.dart';

const Color _backgroundColor = appWhite;

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final pwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context);

    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        color: _backgroundColor,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 72),
              ClipOval(
                child: Image.asset(
                  'assets/images/keep-logo-square512.png',
                  height: 100,
                ),
              ),
              SizedBox(height: 36),
              Text(
                'Welcome to Keep!',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    color: appIconGrey,
                    fontSize: 34),
              ),
              SizedBox(height: 8),
              Text(
                'Sign in to continue',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.grey,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 64),
              LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _loginFormKey = GlobalKey<FormState>();

  final _usernameKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  FocusNode usernameFocusNode;
  FocusNode passwordFocusNode;

  @override
  void initState() {
    super.initState();

    usernameFocusNode = FocusNode();
    passwordFocusNode = FocusNode();

    usernameFocusNode.addListener(() => setState(() {}));
    passwordFocusNode.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TextFormFieldContainer(
            textFormFieldKey: _usernameKey,
            controller: _usernameController,
            focusNode: usernameFocusNode,
            autofocus: true,
            fieldValidator: (username) {},
            prefixIconData: Icons.person_outline,
            labelText: 'USERNAME',
          ),
          SizedBox(height: 32),
          _TextFormFieldContainer(
            textFormFieldKey: _passwordKey,
            controller: _passwordController,
            focusNode: passwordFocusNode,
            fieldValidator: (pwd) {},
            prefixIconData: Icons.lock_outline,
            labelText: 'PASSWORD',
          ),
          Container(
              // color: Colors.indigo[200],
              padding: EdgeInsets.only(top: 4, bottom: 24),
              alignment: Alignment.centerRight,
              child: FlatButton(
                onPressed: () {},
                color: _backgroundColor,
                splashColor: _backgroundColor, // remove default splash
                child: Text(
                  'Forgot password?',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: NoteColor.orange.getColor(),
                      fontWeight: FontWeight.w500),
                ),
              )),
          FlatButton(
            color: NoteColor.orange.getColor(),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            padding: EdgeInsets.symmetric(vertical: 12),
            onPressed: () {},
            child: Text(
              'LOGIN',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: _backgroundColor),
            ),
          )
        ],
      ),
    );
  }
}

class _TextFormFieldContainer extends StatelessWidget {
  final GlobalKey<FormFieldState> textFormFieldKey;
  final TextEditingController controller;
  final bool autofocus;
  final FocusNode focusNode;

  final String Function(String) fieldValidator;

  final IconData prefixIconData;
  final String labelText;

  _TextFormFieldContainer(
      {@required this.textFormFieldKey,
      @required this.controller,
      this.autofocus = false,
      @required this.focusNode,
      @required this.fieldValidator,
      @required this.prefixIconData,
      @required this.labelText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(4, 6, 4, 4),
      decoration: BoxDecoration(
        color: _backgroundColor,
        boxShadow: focusNode.hasFocus
            ? [BoxShadow(blurRadius: 6, color: Colors.grey[300])]
            : null,
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextFormField(
        key: textFormFieldKey,
        controller: controller,
        focusNode: focusNode,
        autofocus: autofocus,
        cursorColor: NoteColor.orange.getColor(),
        validator: fieldValidator,
        onChanged: (_) {
          textFormFieldKey.currentState.validate();
        },
        style: TextStyle(
          fontSize: 15,
          fontFamily: 'MONTSERRAT',
          fontWeight: FontWeight.w500,
          color: NoteColor.orange.getColor(),
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            prefixIconData,
            size: 26,
            color: (focusNode.hasFocus)
                ? NoteColor.orange.getColor()
                : Colors.grey,
          ),
          contentPadding: EdgeInsets.zero,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          labelText: labelText,
          labelStyle: TextStyle(
              fontSize: 14,
              fontFamily: 'MONTSERRAT',
              fontWeight: FontWeight.w500,
              color: Colors.grey),
        ),
      ),
    );
  }
}
