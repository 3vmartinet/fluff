import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityRepo {
  Future<bool> hasConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    return results.firstOrNull != ConnectivityResult.none;
  }
}
