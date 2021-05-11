import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ten_minute/widgets/text_widgets.dart';

import '../consts.dart';
import '../controller.dart';
import '../widgets/days_container_widgets.dart';
import 'days_screen.dart';

class my_videos extends StatefulWidget {
  @override
  _my_videosState createState() => _my_videosState();
}

class _my_videosState extends State<my_videos> {
  final Controller_get cs = Get.put(Controller_get());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors().grey,
        appBar: AppBar(
          title: little_text_grey(title: "My videos", value: MediaQuery.of(context).size.width*15/411),
          backgroundColor: colors().brown,
          leading: BackButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => days_screen()));
          }),
        ),
        body: Column(
          children: [
            Expanded(
              child: GridView.builder(
                  physics: BouncingScrollPhysics(),
                  primary: false,
                  padding: EdgeInsets.all(1),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: MediaQuery.of(context).size.width*200/411,
                    crossAxisSpacing: MediaQuery.of(context).size.width*5/411,
                    mainAxisSpacing: MediaQuery.of(context).size.width*8/411,
                  ),
                  itemCount: cs.day_calculator.value.toInt(),
                  itemBuilder: (context, index) => Container(
                        color: Colors.yellow,
                        child: watch(index: index, context: context),
                      )),
            ),
          BannerAdWidget(AdSize.banner) == null || cs.premium_account.toString()=="true"?Container(height: MediaQuery.of(context).size.width*50/411
            ):BannerAdWidget(AdSize.banner),
          ],
        ));
  }
}

class BannerAdWidget extends StatefulWidget {
  BannerAdWidget(this.size);

  final AdSize size;

  @override
  State<StatefulWidget> createState() => BannerAdState();
}

class BannerAdState extends State<BannerAdWidget> {
   BannerAd _bannerAd;
  final Completer<BannerAd> bannerCompleter = Completer<BannerAd>();

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: "ca-app-pub-9033499140406083/9795464273",
      request: AdRequest(),
      size: widget.size,
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          print('$BannerAd loaded.');
          bannerCompleter.complete(ad as BannerAd);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('$BannerAd failedToLoad: $error');
          bannerCompleter.completeError(error);
        },
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
        onApplicationExit: (Ad ad) => print('$BannerAd onApplicationExit.'),
      ),
    );
    Future<void>.delayed(Duration(seconds: 1), () => _bannerAd.load());
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BannerAd>(
      future: bannerCompleter.future,
      builder: (BuildContext context, AsyncSnapshot<BannerAd> snapshot) {
        Widget child;

        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            child = Container();
            break;
          case ConnectionState.done:
            if (snapshot.hasData) {
              child = AdWidget(ad: _bannerAd);
            } else {
              child = Text('Error loading $BannerAd');
            }
        }

        return Container(
          width: _bannerAd.size.width.toDouble(),
          height: _bannerAd.size.height.toDouble(),
          color: Colors.blueGrey,
          child: child,
        );
      },
    );
  }
}