import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:homescreen/authentication/authentication.dart';
import 'package:homescreen/authentication/bloc/bloc.dart';
import 'package:meta/meta.dart';
import './bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;
  AuthenticationBloc _authenticationBloc;

  LoginBloc(
      {@required UserRepository userRepository,
      @required AuthenticationBloc authenticationBloc})
      : assert(userRepository != null),
        assert(authenticationBloc != null),
        _userRepository = userRepository,
        _authenticationBloc = authenticationBloc;

  @override
  LoginState get initialState => LoginInitital();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginInWithGoogle) {
      try {
        await _userRepository.signInWithGoogle(_authenticationBloc);
        _authenticationBloc.dispatch(LoggedIn());
        yield LoginInitital();
      } catch (_) {
        yield LoginFailure(error: _);
      }
    }
  }
}
