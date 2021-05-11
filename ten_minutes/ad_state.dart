

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ten_minute/screens/days_screen.dart';

class AdState {
  Future<InitializationStatus> initialization;

  AdState(this.initialization);



  String get bannerAdUnitId => "ca-app-pub-9033499140406083/9795464273";
  ///ca-app-pub-9033499140406083/9795464273
  ///
  String get videoad => "ca-app-pub-9033499140406083/1785074327";

  /// ca-app-pub-9033499140406083/1785074327

  AdListener get adListener => _adListener;
  AdListener _adListener = AdListener(
    onAdLoaded: (ad) => print("ad loaded: ${ad.adUnitId}."),
    onAdClosed: (ad) => print("ad closed: ${ad.adUnitId}."),
    onAdFailedToLoad: (ad,error) => print("ad failed to load: ${ad.adUnitId}, $error."),
    onAdOpened: (ad) => print("ad opened: ${ad.adUnitId}."),
    onAppEvent: (ad, name, data) => print("app event: ${ad.adUnitId}, $name, $data."),
    onApplicationExit: (ad) => print("App exit: ${ad.adUnitId}."),
    onNativeAdClicked: (nativeAd) => print("Native ad clicked: ${nativeAd.adUnitId}."),
    onNativeAdImpression: (nativeAd) => print("Native ad impression: ${nativeAd.adUnitId}."),
    onRewardedAdUserEarnedReward: (ad, reward) => print("User rewarded: ${ad.adUnitId}, ${reward.amount} ${reward.type}."),
  );

  final AdListener listener = AdListener(
 // Called when an ad is successfully received.
 onAdLoaded: (Ad ad) => print('Ad loaded.'),
 // Called when an ad request failed.
 onAdFailedToLoad: (Ad ad, LoadAdError error) {
   ad.dispose();
   print('Ad failed to load: $error');
 },
 // Called when an ad opens an overlay that covers the screen.
 onAdOpened: (Ad ad) => print('Ad opened.'),
 // Called when an ad removes an overlay that covers the screen.
 onAdClosed: (Ad ad) {
   ad.dispose();
   print('Ad closed.');
 },
 // Called when an ad is in the process of leaving the application.
 onApplicationExit: (Ad ad) => print('Left application.'),
);


  

}