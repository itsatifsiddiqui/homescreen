import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ConnectivityState extends Equatable {
  ConnectivityState([List props = const []]) : super(props);
}

class InitialConnectivityState extends ConnectivityState {}

class Connected extends ConnectivityState {
  @override
  String toString() => "Connected";
}

class NotConnected extends ConnectivityState {
  @override
  String toString() => " Not Connected";
}
