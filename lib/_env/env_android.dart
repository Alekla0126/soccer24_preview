import 'package:envied/envied.dart';

part 'env_android.g.dart';

@Envied(path: '.env.android')
abstract class Env {
  @EnviedField(varName: 'API_FOOTBALL_BASE_URL', obfuscate: true)
  static String apiFootballBaseUrl = _Env.apiFootballBaseUrl;

  @EnviedField(varName: 'API_FOOTBALL_KEY', obfuscate: true)
  static String apiFootballKey = _Env.apiFootballKey;

  @EnviedField(varName: 'API_FOOTBALL_API_KEY', obfuscate: true)
  static String apiFootballApiKey = _Env.apiFootballApiKey;

  // Android-specific AdMob IDs
  @EnviedField(varName: 'ANDROID_ADMOB_BANNER_ID', obfuscate: true)
  static String admobBannerId = _Env.admobBannerId;

  @EnviedField(varName: 'ANDROID_ADMOB_MREC_ID', obfuscate: true)
  static String admobMrecId = _Env.admobMrecId;

  @EnviedField(varName: 'ANDROID_ADMOB_INTERSTITIAL_ID', obfuscate: true)
  static String admobInterstitialId = _Env.admobInterstitialId;

  @EnviedField(varName: 'ANDROID_ADMOB_APP_OPEN_ID', obfuscate: true)
  static String admobAppOpenId = _Env.admobAppOpenId;

  // AppLovin and OneSignal
  @EnviedField(varName: 'APPLOVIN_SDK_KEY', obfuscate: true)
  static final String applovinSdkKey = _Env.applovinSdkKey;

  @EnviedField(varName: 'APPLOVIN_BANNER_ID', obfuscate: true)
  static final String applovinBannerId = _Env.applovinBannerId;

  @EnviedField(varName: 'APPLOVIN_MREC_ID', obfuscate: true)
  static final String applovinMrecId = _Env.applovinMrecId;

  @EnviedField(varName: 'APPLOVIN_INTERSTITIAL_ID', obfuscate: true)
  static final String applovinInterstitialId = _Env.applovinInterstitialId;

  @EnviedField(varName: 'ONE_SIGNAL_APP_ID', obfuscate: true)
  static String oneSignalAppId = _Env.oneSignalAppId;
}