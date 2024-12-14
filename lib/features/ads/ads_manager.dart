import 'dart:async';

import 'package:flutter/material.dart';

import 'admob/admob_banner_ad.dart';
import 'admob/admob_manager.dart';
import 'admob/admob_mrec_ad.dart';
import 'applovin/applovin_banner_ad.dart';
import 'applovin/applovin_manager.dart';
import 'applovin/applovin_mrec_ad.dart';

enum AdNetwork { admob, applovin }

class AdsManager {
  AdsManager._();

  static final AdsManager _instance = AdsManager._();

  static AdsManager get instance => _instance;

  final AdNetwork adNetwork = AdNetwork.admob;

  //////////////////////////////////
  Future initializeAds() async {
    if (adNetwork == AdNetwork.admob) {
      await AdmobManager.instance.initializeAdmob();
    } else if (adNetwork == AdNetwork.applovin) {
      await ApplovinManager.instance.initApplovin();
    }
  }

  void showInterstitialAd() {
    if (adNetwork == AdNetwork.admob) {
      AdmobManager.instance.showInterstitialAd();
    } else if (adNetwork == AdNetwork.applovin) {
      ApplovinManager.instance.showInterstitialAd();
    }
  }

  Widget bannerAd() {
    if (adNetwork == AdNetwork.admob) {
      return const AdmobBannerAd();
    } else if (adNetwork == AdNetwork.applovin) {
      return const ApplovinBannerAd();
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget mrecAd() {
    if (adNetwork == AdNetwork.admob) {
      return const AdmobMRecAd();
    } else if (adNetwork == AdNetwork.applovin) {
      return const ApplovinMRecAd();
    } else {
      return const SizedBox.shrink();
    }
  }
}
