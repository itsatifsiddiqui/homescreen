import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homescreen/authentication/authentication.dart';
import 'package:homescreen/connectivity/bloc/bloc.dart';
import 'package:homescreen/login/bloc/bloc.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:homescreen/posts/Post.dart';
import '../../Test/test_functions.dart';

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
  ConnectivityBloc _connectivityBloc;

  UserRepository get _userRepository => widget._userRepository;

  @override
  void initState() {
    super.initState();
    _connectivityBloc = ConnectivityBloc();
    _connectivityBloc.dispatch(CheckConnectivity());
    _loginBloc = LoginBloc(
      userRepository: _userRepository,
      connectivityBloc: _connectivityBloc,
      authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    print(_connectivityBloc);
    final mq = MediaQuery.of(context).size;
    return BlocBuilder(
        bloc: _connectivityBloc,
        builder: (context, ConnectivityState state) {
          return Scaffold(
            key: _scaffoldKey,
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
                      // onPressed: () {
                      //   for (var i = 0; i < 31; i++) {
                      //     addPost(i);
                      //   }
                      //   // deleteAll();
                      // },
                      onPressed: () {
                        if (state is Connected) {
                          _loginBloc.dispatch(LoginInWithGoogle());
                        } else {
                          showScaffold(_scaffoldKey);
                        }
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(1.7, 0.55),
                  child: Container(
                    width: mq.width / 1.2,
                    height: mq.height / 12,
                    child: FacebookSignInButton(
                      onPressed: () {
                        if (state is Connected) {
                          _loginBloc.dispatch(LoginWithFacebook());
                        } else {
                          showScaffold(_scaffoldKey);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    _connectivityBloc.dispose();
    super.dispose();
  }

  void showScaffold(GlobalKey<ScaffoldState> _scaffoldKey) {
    _connectivityBloc.dispatch(CheckConnectivity());
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.red.shade700,
      content: Text(
        "No Intenet Connection\nPlease Check Your Internet Settings",
        textAlign: TextAlign.center,
      ),
    ));
  }
}
