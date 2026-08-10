import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtils {
  static Future<bool> checkInternet() async {
    if((await Connectivity().checkConnectivity()).contains(ConnectivityResult.none)) return false;
    try {
      var result = await InternetAddress.lookup('flutter.dev');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (e) {
      if (e.osError?.errorCode == 7) {
        return false;
      } else {
        log('SocketException: $e');
        return false;
      }
    } catch (e) {
      log('Unexpected error: $e');
      return false;
    }
    return false;
  }

}