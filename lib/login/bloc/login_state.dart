import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginState extends Equatable {
  LoginState([List props = const []]) : super(props);
}

class LoginInitital extends LoginState {
  @override
  String toString() => "LoginInitial";
}


class LoginFailure extends LoginState {
  final String error;
  LoginFailure({this.error}) : super([error]);
  String toString() => "LoginFailure: { error: $error }";
}
