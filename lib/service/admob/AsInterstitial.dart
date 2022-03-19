import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:search_assistant/main.dart';

class AdInterstitial {
  InterstitialAd? _interstitialAd;
  int num_of_attempt_load = 0;
  bool? ready;

  void createAd() {
    InterstitialAd.load(
        adUnitId: interstitialAdUnitId,
        request: const AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
      print('add loaded');
      _interstitialAd = ad;
      num_of_attempt_load = 0;
      ready = true;
    },
      onAdFailedToLoad: (LoadAdError error) {
        num_of_attempt_load++;
        _interstitialAd = null;
        if (num_of_attempt_load <= 2) {
          createAd();
        }
      },
    ),
    );
  }
  Future<void> showAd() async {
    ready = false;
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        print("ad onAdshowedFullscreen");
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print("ad Disposed");
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError aderror) {
        print('$ad OnAdFailed $aderror');
        ad.dispose();
        createAd();
      },
    );

    // 広告の表示には.show()を使う
    await _interstitialAd!.show();
    _interstitialAd = null;
  }
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8481794717512198/6495262255';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-8481794717512198/5707242778';
    } else {
      //どちらでもない場合は、テスト用を返す
      return BannerAd.testAdUnitId;
    }
  }
}