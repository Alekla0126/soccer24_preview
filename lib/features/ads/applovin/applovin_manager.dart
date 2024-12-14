import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';
import '../../../_env/env.dart';
import 'dart:math';



class ApplovinManager {
  ApplovinManager._();

  static final ApplovinManager _instance = ApplovinManager._();

  static ApplovinManager get instance => _instance;

  int _interstitialRetryAttempt = 0;

  Future<void> initApplovin() async {
    final MaxConfiguration? sdkConfiguration = await AppLovinMAX.initialize(Env.applovinSdkKey);

    AppLovinMAX.setVerboseLogging(false);

    // AppLovinMAX.showMediationDebugger();

    if (sdkConfiguration != null) {
      // SDK is initialized, start loading ads
      _initializeInterstitialAds();
    }
  }

  void _initializeInterstitialAds() {
    AppLovinMAX.setInterstitialListener(InterstitialListener(
      onAdLoadedCallback: (ad) {
        // Reset retry attempt
        _interstitialRetryAttempt = 0;
      },
      onAdLoadFailedCallback: (adUnitId, error) {
        // Interstitial ad failed to load
        // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
        _interstitialRetryAttempt = _interstitialRetryAttempt + 1;

        final int retryDelay = pow(2, min(6, _interstitialRetryAttempt)).toInt();

        debugPrint(
            'Interstitial ad failed to load with code ${error.code} - retrying in ${retryDelay}s');

        Future.delayed(Duration(milliseconds: retryDelay * 1000), () {
          AppLovinMAX.loadInterstitial(adUnitId);
        });
      },
      onAdDisplayedCallback: (ad) {
        debugPrint('Interstitial ad onAdDisplayedCallback - $ad');
      },
      onAdDisplayFailedCallback: (ad, error) {
        debugPrint('Interstitial ad onAdDisplayFailedCallback - $ad - $error');
      },
      onAdClickedCallback: (ad) {
        debugPrint('Interstitial ad onAdClickedCallback - $ad');
      },
      onAdHiddenCallback: (ad) {
        debugPrint('Interstitial ad onAdHiddenCallback - $ad');
        AppLovinMAX.loadInterstitial(Env.applovinInterstitialId);
      },
    ));

    // Load the first interstitial
    AppLovinMAX.loadInterstitial(Env.applovinInterstitialId);
  }

  Future showInterstitialAd() async {
    final bool isReady = await AppLovinMAX.isInterstitialReady(Env.applovinInterstitialId) ?? false;
    if (!isReady) {
      _initializeInterstitialAds();
    } else {
      AppLovinMAX.showInterstitial(Env.applovinInterstitialId);
    }
  }
}