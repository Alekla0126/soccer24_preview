import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../constants/constants.dart';
import 'package:flutter/material.dart';
import '../../../_env/env.dart';
import 'admob_manager.dart';

class AdmobBannerAd extends StatefulWidget {
  const AdmobBannerAd({super.key});


  @override
  State<AdmobBannerAd> createState() => _AdmobBannerAdState();
}

class _AdmobBannerAdState extends State<AdmobBannerAd> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  late final String adUnitId;

  @override
  void initState() {
    super.initState();
    adUnitId = AdmobManager.instance.testMode
        ? Constants.admobBannerAdUnitIdTest
        : Env.admobBannerId;
        // Constants.admobBannerAdUnitIdTest;
    _bannerAd = loadBannerAd(adUnitId, () {
      setState(() => _isLoaded = true);
    });
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !_isLoaded
        ? const SizedBox.shrink()
        : SafeArea(
            child: SizedBox(
              width: double.infinity,
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          );
  }

  BannerAd loadBannerAd(String adUnitId, VoidCallback onAdLoaded) {
    final BannerAd bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('AdmobManager: $ad loaded.');
          onAdLoaded();
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, error) {
          debugPrint('AdmobManager: BannerAd failed to load: $error');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {
          debugPrint('AdmobManager: $ad opened.');
        },
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {
          debugPrint('AdmobManager: $ad closed.');
        },
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {
          debugPrint('AdmobManager: $ad impression.');
        },
      ),
    )..load();

    return bannerAd;
  }
}
