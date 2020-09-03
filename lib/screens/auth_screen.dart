import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/auth_bloc.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:provider/provider.dart';

const Color _backgroundColor = appWhite;

final _forgotPwdStyle = TextStyle(
    fontFamily: 'Montserrat',
    color: NoteColor.orange.getColor(),
    fontWeight: FontWeight.w500);

final _titleStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w400,
    color: appIconGrey,
    fontSize: 34);

const double _donthaveAccountTextSpacing = 24;

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                style: _titleStyle,
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
              SizedBox(height: _donthaveAccountTextSpacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: _forgotPwdStyle.copyWith(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ));
                    },
                    child: Container(
                      color: _backgroundColor,
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: Text(
                        'Sign up',
                        style: _forgotPwdStyle,
                      ),
                    ),
                  ),
                ],
              ),
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
    var authBloc = Provider.of<AuthBloc>(context);

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
            textInputAction: TextInputAction.next,
            onEditingComplete: () {
              passwordFocusNode.requestFocus();
            },
            fieldValidator: (username) {
              if (username.isEmpty) {
                return 'Required';
              }
            },
            prefixIconData: Icons.person_outline,
            labelText: 'USERNAME',
          ),
          SizedBox(height: 32),
          _TextFormFieldContainer(
            obscureText: true,
            textFormFieldKey: _passwordKey,
            controller: _passwordController,
            focusNode: passwordFocusNode,
            textInputAction: TextInputAction.done,
            validateOnEveryChange: true,
            fieldValidator: (pwd) {
              if (pwd.length < 8) {
                return 'Should have at least 8 characters!';
              }
            },
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
                highlightColor: _backgroundColor,
                child: Text(
                  'Forgot password?',
                  style: _forgotPwdStyle,
                ),
              )),
          FlatButton(
            color: NoteColor.orange.getColor(),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            padding: EdgeInsets.symmetric(vertical: 12),
            onPressed: () async {
              if (_loginFormKey.currentState.validate()) {
                var loginError = await authBloc.login(
                    _usernameController.text, _passwordController.text);

                String m;

                switch (loginError) {
                  case LoginError.usernameNotFound:
                    m = "Couldn't find a user with this username";
                    Scaffold.of(context).showSnackBar(_authErrorSnackBar(m));
                    break;
                  case LoginError.wrongPwd:
                    m = 'Wrong password';
                    Scaffold.of(context).showSnackBar(_authErrorSnackBar(m));
                    break;
                  case LoginError.userDisabled:
                    m = 'You did not sign in correctly or your account is temporarily disabled';
                    Scaffold.of(context).showSnackBar(_authErrorSnackBar(m));
                    break;
                  case LoginError.invalidEmail:
                    m = 'Sign in failed. Internal error.';
                    Scaffold.of(context).showSnackBar(_authErrorSnackBar(m));
                    break;
                  case LoginError.emailNotFound:
                    m = 'Sign in failed. Internal error.';
                    Scaffold.of(context).showSnackBar(_authErrorSnackBar(m));
                    break;
                  case LoginError.authenticationUnavailable:
                    m = "Login failed... Do you have an internet connection?";
                    Scaffold.of(context).showSnackBar(_authErrorSnackBar(m));
                    break;
                  case LoginError.unknown:
                    m = "We couldn't sign you in. Please try again later";
                    Scaffold.of(context).showSnackBar(_authErrorSnackBar(m));
                    break;
                  default:
                    print('success');
                }
              }
            },
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

SnackBar _authErrorSnackBar(String message) {
  return SnackBar(
    backgroundColor: Colors.red[400],
    content: Text(
      message,
      style: TextStyle(
          color: appWhite,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500),
    ),
  );
}

class _TextFormFieldContainer extends StatelessWidget {
  final GlobalKey<FormFieldState> textFormFieldKey;
  final TextEditingController controller;
  final bool autofocus;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final bool obscureText;
  final String Function(String) fieldValidator;
  final void Function() onEditingComplete;
  final IconData prefixIconData;
  final String labelText;
  final bool validateOnEveryChange;

  _TextFormFieldContainer(
      {@required this.textFormFieldKey,
      @required this.controller,
      this.autofocus = false,
      this.onEditingComplete,
      this.obscureText = false,
      @required this.focusNode,
      @required this.fieldValidator,
      this.validateOnEveryChange = false,
      @required this.prefixIconData,
      @required this.labelText,
      @required this.textInputAction});

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
        maxLines: 1,
        controller: controller,
        obscureText: obscureText,
        textInputAction: textInputAction,
        focusNode: focusNode,
        autofocus: autofocus,
        onEditingComplete: onEditingComplete,
        cursorColor: NoteColor.orange.getColor(),
        validator: fieldValidator,
        onChanged: (_) {
          if (validateOnEveryChange) {
            textFormFieldKey.currentState.validate();
          }
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
          focusedErrorBorder: InputBorder.none,
          errorStyle:
              TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w500),
          errorMaxLines: 1,
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

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: appIconGrey),
        backgroundColor: _backgroundColor,
        elevation: 0,
      ),
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
              ClipOval(
                child: Image.asset(
                  'assets/images/keep-logo-square512.png',
                  height: 100,
                ),
              ),
              SizedBox(height: 36),
              Text(
                'Sign Up',
                style: _titleStyle,
              ),
              SizedBox(height: 24),
              SignUpForm(),
              SizedBox(height: _donthaveAccountTextSpacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: _forgotPwdStyle.copyWith(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      color: _backgroundColor,
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: Text(
                        'Log in',
                        style: _forgotPwdStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  static const double _formFieldSpacing = 20;
  final _signUpFormKey = GlobalKey<FormState>();

  final _usernameKey = GlobalKey<FormFieldState>();
  final _emailKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();
  final _confirmPasswordKey = GlobalKey<FormFieldState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  FocusNode usernameFocusNode;
  FocusNode emailFocusNode;
  FocusNode passwordFocusNode;
  FocusNode confirmPasswordFocusNode;

  @override
  void initState() {
    super.initState();

    usernameFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();

    usernameFocusNode.addListener(() => setState(() {}));
    emailFocusNode.addListener(() => setState(() {}));
    passwordFocusNode.addListener(() => setState(() {}));
    confirmPasswordFocusNode.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context);

    return Form(
      key: _signUpFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TextFormFieldContainer(
            textFormFieldKey: _usernameKey,
            controller: _usernameController,
            focusNode: usernameFocusNode,
            textInputAction: TextInputAction.next,
            onEditingComplete: () {
              emailFocusNode.requestFocus();
            },
            fieldValidator: (username) {
              if (username.isEmpty) {
                return 'Required';
              } else if (username.length < 4) {
                return 'Too short';
              } else {
                var regex = RegExp(r"^_{0,2}[a-zA-Z0-9]+_{0,2}$");
                if (!regex.hasMatch(username)) {
                  return 'Invalid username';
                }
              }
            },
            prefixIconData: Icons.person_outline,
            labelText: 'USERNAME',
          ),
          SizedBox(height: _formFieldSpacing),
          _TextFormFieldContainer(
            textFormFieldKey: _emailKey,
            controller: _emailController,
            focusNode: emailFocusNode,
            textInputAction: TextInputAction.next,
            onEditingComplete: () {
              passwordFocusNode.requestFocus();
            },
            fieldValidator: (email) {
              if (email.isEmpty) {
                return 'Required';
              } else {
                var regex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                if (!regex.hasMatch(email)) {
                  return 'Invalid email';
                }
              }
            },
            prefixIconData: Icons.mail_outline,
            labelText: 'EMAIL',
          ),
          SizedBox(height: _formFieldSpacing),
          _TextFormFieldContainer(
            obscureText: true,
            textFormFieldKey: _passwordKey,
            controller: _passwordController,
            focusNode: passwordFocusNode,
            textInputAction: TextInputAction.next,
            onEditingComplete: () {
              confirmPasswordFocusNode.requestFocus();
            },
            validateOnEveryChange: true,
            fieldValidator: (pwd) {
              if (pwd.length < 8) {
                return 'Should have at least 8 characters!';
              } else {
                var hasAnyNumber = RegExp(r"(?=.*[0-9])");
                if (!hasAnyNumber.hasMatch(pwd)) {
                  return 'Should have at least one number';
                }
              }
            },
            prefixIconData: Icons.lock_outline,
            labelText: 'PASSWORD',
          ),
          SizedBox(height: _formFieldSpacing),
          _TextFormFieldContainer(
            obscureText: true,
            textFormFieldKey: _confirmPasswordKey,
            controller: _confirmPasswordController,
            focusNode: confirmPasswordFocusNode,
            textInputAction: TextInputAction.done,
            fieldValidator: (pwdConfirmation) {
              if (pwdConfirmation != _passwordController.text) {
                return "Password confirmation doesn't match";
              }
            },
            prefixIconData: Icons.lock_outline,
            labelText: 'CONFIRM PASSWORD',
          ),
          SizedBox(height: 32),
          FlatButton(
            color: NoteColor.orange.getColor(),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            padding: EdgeInsets.symmetric(vertical: 12),
            onPressed: () async {
              if (_signUpFormKey.currentState.validate()) {
                var signupError = await authBloc.signup(
                    _usernameController.text,
                    _emailController.text,
                    _passwordController.text);

                String m;

                switch (signupError) {
                  case SignUpError.usernameAlreadyInUse:
                    m = "This username is already in use";
                    Scaffold.of(context).showSnackBar(_authErrorSnackBar(m));
                    break;
                  case SignUpError.authenticationUnavailable:
                    m = 'Sign up failed... Do you have an internet connection?';
                    Scaffold.of(context).showSnackBar(_authErrorSnackBar(m));
                    break;
                  case SignUpError.emailAlreadyInUse:
                    m = 'This email is already in use';
                    Scaffold.of(context).showSnackBar(_authErrorSnackBar(m));
                    break;
                  case SignUpError.invalidEmail:
                    m = 'Invalid email';
                    Scaffold.of(context).showSnackBar(_authErrorSnackBar(m));
                    break;
                  case SignUpError.weakPassword:
                    m = 'Password is too weak! Avoid using whole words and throw some numbers in there!';
                    Scaffold.of(context).showSnackBar(_authErrorSnackBar(m));
                    break;
                  case SignUpError.unknown:
                    m = "Sign up failed... Please try again later";
                    Scaffold.of(context).showSnackBar(_authErrorSnackBar(m));
                    break;

                  default:
                    print('success');
                    Navigator.pop(context);
                }
              }
            },
            child: Text(
              'SIGN UP',
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
