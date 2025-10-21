import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityRepo {
  Future<bool> hasConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    return connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi);
  }
}
