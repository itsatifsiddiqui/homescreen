import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  AuthenticationState([List props = const []]) : super(props);
}

class Uninitialized extends AuthenticationState {
  @override
  String toString() => 'Uninitialized';
}

class Authenticated extends AuthenticationState {
  final FirebaseUser firebaseUser;

  Authenticated(this.firebaseUser) : super([firebaseUser]);

  @override
  String toString() => 'Authenticated { displayName: $firebaseUser }';
}

class Authenticating extends AuthenticationState {
  @override
  String toString() => 'Authenticating';
}

class Unauthenticated extends AuthenticationState {
  @override
  String toString() => 'Unauthenticated';
}
