import 'package:flutter/material.dart';
import 'package:keep_notes_clone/blocs/auth_bloc.dart';
import 'package:keep_notes_clone/utils/colors.dart';
import 'package:provider/provider.dart';

const Color _backgroundColor = appWhite;

TextStyle _forgotPwdStyle(double mediaQueryScreenWidth) => TextStyle(
    fontFamily: 'Montserrat',
    color: NoteColor.orange.getColor(),
    fontWeight: FontWeight.w500,
    fontSize: mediaQueryScreenWidth * 0.034);

TextStyle _titleStyle(double mediaQueryScreenWidth) => TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w400,
    color: appIconGrey,
    fontSize: mediaQueryScreenWidth * 0.083);

double _donthaveAccountTextSpacing(double mediaQueryScreenHeight) =>
    mediaQueryScreenHeight * 0.023;

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mediaQuerySize = MediaQuery.of(context).size;

    return Scaffold(
      key: ValueKey('login_screen'),
      body: Container(
        constraints: BoxConstraints.expand(),
        color: _backgroundColor,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(mediaQuerySize.width * 0.078),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: mediaQuerySize.height * 0.085),
              ClipOval(
                child: Image.asset(
                  'assets/images/keep-logo-square512.png',
                  height: mediaQuerySize.height * 0.118,
                ),
              ),
              SizedBox(height: mediaQuerySize.height * 0.043),
              Text(
                'Welcome to Keep!',
                style: _titleStyle(mediaQuerySize.width),
              ),
              SizedBox(height: mediaQuerySize.height * 0.009),
              Text(
                'Sign in to continue',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontSize: mediaQuerySize.width * 0.034,
                ),
              ),
              SizedBox(height: mediaQuerySize.width * 0.076),
              _LoginForm(mediaQuerySize),
              SizedBox(
                  height: _donthaveAccountTextSpacing(mediaQuerySize.height)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: _forgotPwdStyle(mediaQuerySize.width)
                        .copyWith(color: Colors.grey),
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
                      padding: EdgeInsets.symmetric(
                          vertical: mediaQuerySize.width * 0.01,
                          horizontal: mediaQuerySize.width * 0.02),
                      child: Text(
                        'Sign up',
                        style: _forgotPwdStyle(mediaQuerySize.width),
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

class _LoginForm extends StatefulWidget {
  final Size mediaQuerySize;

  _LoginForm(this.mediaQuerySize);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
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
            mediaQuerySize: widget.mediaQuerySize,
            containerKey: ValueKey('login_username'),
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
              return null;
            },
            prefixIconData: Icons.person_outline,
            labelText: 'USERNAME',
          ),
          SizedBox(height: widget.mediaQuerySize.height * 0.03),
          _TextFormFieldContainer(
            mediaQuerySize: widget.mediaQuerySize,
            containerKey: ValueKey('login_pwd'),
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
              return null;
            },
            prefixIconData: Icons.lock_outline,
            labelText: 'PASSWORD',
          ),
          Container(
              padding:
                  EdgeInsets.only(bottom: widget.mediaQuerySize.height * 0.028),
              alignment: Alignment.centerRight,
              child: FlatButton(
                onPressed: () {},
                color: _backgroundColor,
                splashColor: _backgroundColor, // remove default splash
                highlightColor: _backgroundColor,
                child: Text(
                  'Forgot password?',
                  style: _forgotPwdStyle(widget.mediaQuerySize.width),
                ),
              )),
          FlatButton(
            key: ValueKey('login_button'),
            color: NoteColor.orange.getColor(),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            padding: EdgeInsets.symmetric(
                vertical: widget.mediaQuerySize.height * 0.014),
            onPressed: () async {
              if (_loginFormKey.currentState.validate()) {
                var loginError = await authBloc.login(
                    _usernameController.text, _passwordController.text);

                String m;

                switch (loginError) {
                  case LoginError.usernameNotFound:
                    m = "Username not found";
                    Scaffold.of(context).showSnackBar(
                        _authErrorSnackBar(m, widget.mediaQuerySize.width));
                    break;
                  case LoginError.wrongPwd:
                    m = 'Wrong password';
                    Scaffold.of(context).showSnackBar(
                        _authErrorSnackBar(m, widget.mediaQuerySize.width));
                    break;
                  case LoginError.userDisabled:
                    m = 'User disabled';
                    Scaffold.of(context).showSnackBar(
                        _authErrorSnackBar(m, widget.mediaQuerySize.width));
                    break;
                  case LoginError.invalidEmail:
                    m = 'Sign in failed. Internal error.';
                    Scaffold.of(context).showSnackBar(
                        _authErrorSnackBar(m, widget.mediaQuerySize.width));
                    break;
                  case LoginError.emailNotFound:
                    m = 'Sign in failed. Internal error.';
                    Scaffold.of(context).showSnackBar(
                        _authErrorSnackBar(m, widget.mediaQuerySize.width));
                    break;
                  case LoginError.authenticationUnavailable:
                    m = "Login failed... Do you have an internet connection?";
                    Scaffold.of(context).showSnackBar(
                        _authErrorSnackBar(m, widget.mediaQuerySize.width));
                    break;
                  case LoginError.unknown:
                    m = "We couldn't sign you in. Please try again later";
                    Scaffold.of(context).showSnackBar(
                        _authErrorSnackBar(m, widget.mediaQuerySize.width));
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
                  fontSize: widget.mediaQuerySize.width * 0.049,
                  color: _backgroundColor),
            ),
          )
        ],
      ),
    );
  }
}

SnackBar _authErrorSnackBar(String message, double mediaScreenWidth) {
  return SnackBar(
    backgroundColor: Colors.red[400],
    content: Text(
      message,
      style: TextStyle(
          color: appWhite,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
          fontSize: mediaScreenWidth * 0.034),
    ),
  );
}

class _TextFormFieldContainer extends StatelessWidget {
  final Size mediaQuerySize;
  final ValueKey<String> containerKey;
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
      {@required this.mediaQuerySize,
      @required this.containerKey,
      @required this.textFormFieldKey,
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
      key: containerKey,
      padding: EdgeInsets.fromLTRB(
        mediaQuerySize.width * 0.01,
        mediaQuerySize.height * 0.007,
        mediaQuerySize.width * 0.01,
        mediaQuerySize.height * 0.005,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        boxShadow: focusNode.hasFocus
            ? [
                BoxShadow(
                    blurRadius: mediaQuerySize.width * 0.015,
                    color: Colors.grey[300])
              ]
            : null,
        borderRadius: BorderRadius.circular(mediaQuerySize.width * 0.01),
      ),
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        cursorHeight: mediaQuerySize.width * 0.056,
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
          fontSize: mediaQuerySize.width * 0.037,
          fontFamily: 'MONTSERRAT',
          fontWeight: FontWeight.w500,
          color: NoteColor.orange.getColor(),
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            prefixIconData,
            size: mediaQuerySize.width * 0.063,
            color: (focusNode.hasFocus)
                ? NoteColor.orange.getColor()
                : Colors.grey,
          ),
          isCollapsed: true,
          contentPadding: EdgeInsets.zero,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          errorStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
            fontSize: mediaQuerySize.width * 0.034,
          ),
          errorMaxLines: 1,
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: mediaQuerySize.width * 0.034,
            fontFamily: 'MONTSERRAT',
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mediaQuerySize = MediaQuery.of(context).size;

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
          padding: EdgeInsets.all(mediaQuerySize.width * 0.078),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/images/keep-logo-square512.png',
                  height: mediaQuerySize.height * 0.118,
                ),
              ),
              SizedBox(height: mediaQuerySize.height * 0.043),
              Text(
                'Sign Up',
                style: _titleStyle(mediaQuerySize.width),
              ),
              SizedBox(height: mediaQuerySize.height * 0.028),
              _SignUpForm(mediaQuerySize),
              SizedBox(
                  height: _donthaveAccountTextSpacing(mediaQuerySize.height)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: _forgotPwdStyle(mediaQuerySize.width)
                        .copyWith(color: Colors.grey),
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
                        style: _forgotPwdStyle(mediaQuerySize.width),
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

class _SignUpForm extends StatefulWidget {
  final Size mediaQuerySize;

  _SignUpForm(this.mediaQuerySize);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<_SignUpForm> {
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
            mediaQuerySize: widget.mediaQuerySize,
            containerKey: ValueKey('signup_username'),
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
              return null;
            },
            prefixIconData: Icons.person_outline,
            labelText: 'USERNAME',
          ),
          SizedBox(height: widget.mediaQuerySize.height * 0.023),
          _TextFormFieldContainer(
            mediaQuerySize: widget.mediaQuerySize,
            containerKey: ValueKey('signup_email'),
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
              return null;
            },
            prefixIconData: Icons.mail_outline,
            labelText: 'EMAIL',
          ),
          SizedBox(height: widget.mediaQuerySize.height * 0.023),
          _TextFormFieldContainer(
            mediaQuerySize: widget.mediaQuerySize,
            containerKey: ValueKey('signup_pwd'),
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
              return null;
            },
            prefixIconData: Icons.lock_outline,
            labelText: 'PASSWORD',
          ),
          SizedBox(height: widget.mediaQuerySize.height * 0.023),
          _TextFormFieldContainer(
            mediaQuerySize: widget.mediaQuerySize,
            containerKey: ValueKey('signup_confirm_pwd'),
            obscureText: true,
            textFormFieldKey: _confirmPasswordKey,
            controller: _confirmPasswordController,
            focusNode: confirmPasswordFocusNode,
            textInputAction: TextInputAction.done,
            fieldValidator: (pwdConfirmation) {
              if (pwdConfirmation != _passwordController.text) {
                return "Password confirmation doesn't match";
              }
              return null;
            },
            prefixIconData: Icons.lock_outline,
            labelText: 'CONFIRM PASSWORD',
          ),
          SizedBox(height: widget.mediaQuerySize.height * 0.037),
          FlatButton(
            color: NoteColor.orange.getColor(),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            padding: EdgeInsets.symmetric(
                vertical: widget.mediaQuerySize.height * 0.014),
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
                    Scaffold.of(context).showSnackBar(
                        _authErrorSnackBar(m, widget.mediaQuerySize.width));
                    break;
                  case SignUpError.authenticationUnavailable:
                    m = 'Sign up failed... Do you have an internet connection?';
                    Scaffold.of(context).showSnackBar(
                        _authErrorSnackBar(m, widget.mediaQuerySize.width));
                    break;
                  case SignUpError.emailAlreadyInUse:
                    m = 'This email is already in use';
                    Scaffold.of(context).showSnackBar(
                        _authErrorSnackBar(m, widget.mediaQuerySize.width));
                    break;
                  case SignUpError.invalidEmail:
                    m = 'Invalid email';
                    Scaffold.of(context).showSnackBar(
                        _authErrorSnackBar(m, widget.mediaQuerySize.width));
                    break;
                  case SignUpError.weakPassword:
                    m = 'Password is too weak! Avoid using whole words and throw some numbers in there!';
                    Scaffold.of(context).showSnackBar(
                        _authErrorSnackBar(m, widget.mediaQuerySize.width));
                    break;
                  case SignUpError.unknown:
                    m = "Sign up failed... Please try again later";
                    Scaffold.of(context).showSnackBar(
                        _authErrorSnackBar(m, widget.mediaQuerySize.width));
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
                  fontSize: widget.mediaQuerySize.width * 0.049,
                  color: _backgroundColor),
            ),
          )
        ],
      ),
    );
  }
}
