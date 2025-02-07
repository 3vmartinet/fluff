import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityRepo {
  static final ConnectivityRepo _instance = ConnectivityRepo._init();
  factory ConnectivityRepo() => _instance;

  ConnectivityRepo._init();

  Future<bool> hasConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    return connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi);
  }
}
