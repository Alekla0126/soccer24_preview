import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../constants/constants.dart';
import 'package:flutter/material.dart';
import '../../../_env/env.dart';

class AdmobManager {
  AdmobManager._();
  static final AdmobManager _instance = AdmobManager._();
  static AdmobManager get instance => _instance;

  InterstitialAd? interstitialAd;
  final bool testMode = false;

  Future initializeAdmob() async {
    await MobileAds.instance.initialize().then(
          (onValue) {
            requestConsentInfoUpdate();
            loadInterstitialAd();
          },
        );
  }

  void requestConsentInfoUpdate() {
    ConsentInformation.instance.reset();
    // final ConsentDebugSettings debugSettings = ConsentDebugSettings(
    //     debugGeography: DebugGeography.debugGeographyEea,
    //     testIdentifiers: ['BC74F2713F6035807D7D076C97D55FB2']);

    final ConsentRequestParameters params =
        ConsentRequestParameters(/*consentDebugSettings: debugSettings*/);
    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        if (await ConsentInformation.instance.isConsentFormAvailable()) {
          _loadForm();
        }
      },
      (FormError error) {
        // Handle the error
      },
    );
  }

  void _loadForm() {
    ConsentForm.loadConsentForm(
      (ConsentForm consentForm) async {
        final status = await ConsentInformation.instance.getConsentStatus();
        if (status == ConsentStatus.required) {
          consentForm.show(
            (FormError? formError) {
              // Handle dismissal by reloading form
              _loadForm();
            },
          );
        }
      },
      (formError) {
        // Handle the error
      },
    );
  }

  /// Loads an interstitial ad.
  void loadInterstitialAd() {
    final String adUnitId =
        testMode ? Constants.admobInterstitialAdUnitIdTest : Env.admobInterstitialId;
        // Constants.admobInterstitialAdUnitIdTest;
    InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
              onAdShowedFullScreenContent: (ad) {
              },
              // Called when an impression occurs on the ad.
              onAdImpression: (ad) {
              },
              // Called when the ad failed to show full screen content.
              onAdFailedToShowFullScreenContent: (ad, err) {
                // Dispose the ad here to free resources.
                ad.dispose();
                loadInterstitialAd();
              },
              // Called when the ad dismissed full screen content.
              onAdDismissedFullScreenContent: (ad) {
                // Dispose the ad here to free resources.
                // canShowInterstitial = true;
                ad.dispose();
                loadInterstitialAd();
              },
              // Called when a click is recorded for an ad.
              onAdClicked: (ad) {},
            );

            debugPrint('AdmobManager: $ad loaded.');
            // Keep a reference to the ad so you can show it later.
            interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('AdmobManager: InterstitialAd failed to load: $error');
          },
        ));
  }

  void showInterstitialAd() {
    if (interstitialAd == null) {
      loadInterstitialAd();
    } else {
      interstitialAd?.show();
    }
  }
}
