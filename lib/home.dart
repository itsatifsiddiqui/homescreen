import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homescreen/authentication/authentication.dart';

class Home extends StatelessWidget {
  final String user;
  final UserRepository repository;

  const Home({Key key, @required this.user, @required this.repository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HOME"),
      ),
      body: Column(
        children: <Widget>[
          Text(user),
          RaisedButton(
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).dispatch(
                LoggedOut(),
              );
            },
            child: Text("LOGOUT"),
          )
        ],
      ),
    );
  }
}
