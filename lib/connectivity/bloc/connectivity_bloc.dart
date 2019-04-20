import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'package:connectivity/connectivity.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  @override
  ConnectivityState get initialState => InitialConnectivityState();

  @override
  Stream<ConnectivityState> mapEventToState(
    ConnectivityEvent event,
  ) async* {
    if (event is CheckConnectivity) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        bool connection = await checkConnection();
        if (connection)
          yield Connected();
        else
          yield NotConnected();
      } else
        yield NotConnected();
    }
  }

  Future<bool> checkConnection() async {
    bool hasConnection;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }
    return hasConnection;
  }
}
