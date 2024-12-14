import 'package:package_info_plus/package_info_plus.dart';
import '../constants/assets.dart';

class AppInfo {
  static late String name;
  static late String packageName;
  static late String iosAppId;
  static const String email = 'alekla0126@gmail.com';
  static const String icon = Assets.appIcon;

  static Future getPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    name = 'Soccer24 - Live Scores and Results';
    packageName = packageInfo.packageName;
  }
}