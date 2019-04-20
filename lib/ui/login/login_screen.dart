import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homescreen/authentication/authentication.dart';
import 'package:homescreen/login/bloc/bloc.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class LoginScreen extends StatefulWidget {
  final UserRepository _userRepository;

  LoginScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(
      userRepository: _userRepository,
      authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment(0, -0.7),
            child: Container(
              width: mq.width / 3,
              height: mq.height / 5,
              child: Placeholder(
                color: Colors.white,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, -0.2),
            child: Text(
              "Home\nScreen",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 35,
                color: Colors.white,
                fontFamily: "koliko",
                fontWeight: FontWeight.w400,
                letterSpacing: 10,
              ),
            ),
          ),
          Align(
            alignment: Alignment(1.7, 0.25),
            child: Container(
              width: mq.width / 1.2,
              height: mq.height / 12,
              child: GoogleSignInButton(
                onPressed: () => _loginBloc.dispatch(LoginInWithGoogle()),
              ),
            ),
          ),
          Align(
            alignment: Alignment(1.7, 0.55),
            child: Container(
              width: mq.width / 1.2,
              height: mq.height / 12,
              child: FacebookSignInButton(
                onPressed: () => _loginBloc.dispatch(LoginInWithFacebook()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
