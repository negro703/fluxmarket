import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

/// Abstract interface for checking network connectivity.
abstract class NetworkInfo {
  /// Returns `true` if the device is connected to the internet.
  Future<bool> get isConnected;

  /// Stream that emits connectivity status changes.
  Stream<bool> get onConnectivityChanged;
}

/// Implementation of [NetworkInfo] using the `connectivity_plus` package.
@LazySingleton(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl(this._connectivity);

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return _evaluateConnectivityResult(results);
  }

  @override
  Stream<bool> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged.map(_evaluateConnectivityResult);

  /// Evaluates a list of [ConnectivityResult] and returns `true` if any
  /// result indicates an active network connection.
  bool _evaluateConnectivityResult(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;
    return results.any((result) => result != ConnectivityResult.none);
  }
}
