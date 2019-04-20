import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homescreen/authentication/authentication.dart';
import 'package:homescreen/authentication/bloc/bloc.dart';
import 'package:homescreen/connectivity/bloc/bloc.dart';
import 'package:meta/meta.dart';
import './bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;
  AuthenticationBloc _authenticationBloc;
  ConnectivityBloc _connectivityBloc;

  LoginBloc(
      {@required UserRepository userRepository,
      @required AuthenticationBloc authenticationBloc,
      @required ConnectivityBloc connectivityBloc})
      : assert(userRepository != null),
        assert(authenticationBloc != null),
        _userRepository = userRepository,
        _authenticationBloc = authenticationBloc,
        _connectivityBloc = connectivityBloc;

  @override
  LoginState get initialState => LoginInitital();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginInWithGoogle) {
      _connectivityBloc.dispatch(CheckConnectivity());
      try {
        _authenticationBloc.dispatch(LoggingIn());
        FirebaseUser user = await _userRepository.signInWithGoogle();
        if (user == null)
          _authenticationBloc.dispatch(LoggedOut());
        else
          _authenticationBloc.dispatch(LoggedIn());
        yield LoginInitital();
      } catch (_) {
        yield LoginFailure(error: _);
      }
    } else if (event is LoginWithFacebook) {
      try {
        _authenticationBloc.dispatch(LoggingIn());
        FirebaseUser user = await _userRepository.signInWithFacebook();
        if (user == null)
          _authenticationBloc.dispatch(LoggedOut());
        else
          _authenticationBloc.dispatch(LoggedIn());
        yield LoginInitital();
      } catch (_) {
        yield LoginFailure(error: _);
      }
    }
  }
}
