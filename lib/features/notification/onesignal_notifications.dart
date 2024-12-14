import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../_env/env.dart';

class OneSignalNotification {
  static Future<void> initializeOneSignal() async {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize(Env.oneSignalAppId);
  }
}
