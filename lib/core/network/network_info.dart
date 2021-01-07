import 'package:data_connection_checker/data_connection_checker.dart';

import 'inetwork_info.dart';

class NetworkInfo implements INetworkInfo {
  final DataConnectionChecker dataConnectionChecker;

  NetworkInfo(this.dataConnectionChecker);

  @override
  Future<bool> get isConnected => dataConnectionChecker.hasConnection;
}
