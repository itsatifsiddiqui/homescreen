import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homescreen/authentication/authentication.dart';
import 'package:homescreen/home.dart';
import 'package:homescreen/simple_bloc_delegate.dart';
import 'package:homescreen/splash/splash_screen.dart';
import 'package:homescreen/ui/login/login_screen.dart';
void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final UserRepository _userRepository = UserRepository();
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
    _authenticationBloc.dispatch(AppStarted());
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      bloc: _authenticationBloc,
      child: MaterialApp(
        home: BlocBuilder(
          bloc: _authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            print("NOW THE STATE IS => => => $state");
            if (state is Uninitialized) {
              return SplashScreen();
            }
            if (state is Authenticating)
              return Scaffold(body: Center(child: CircularProgressIndicator()));

            if (state is Unauthenticated) {
              return LoginScreen(userRepository: _userRepository);
            }

            if (state is Authenticated) {
              return Home(
                user: state.firebaseUser,
                repository: _userRepository,
              );
            }
          },
        ),
      ),
    );
  }
}
