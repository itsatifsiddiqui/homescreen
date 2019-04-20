import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ConnectivityEvent extends Equatable {
  ConnectivityEvent([List props = const []]) : super(props);
}

class CheckConnectivity extends ConnectivityEvent {}
