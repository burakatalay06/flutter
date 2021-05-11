import 'dart:async';

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:ten_minute/providermodel.dart';

import 'controller.dart';
import 'screens/days_screen.dart';
import 'screens/welcome_screen.dart';
import 'widgets/camera_widget.dart';
import 'ad_state.dart';

//TODO:forgot password mailini değiştir ve istersen mail onaylaması koy :)
//TODO: SÜRÜM KONTROLÜ İLK PATH D:\project\ten_minute\android\app\build.gradle
//TODO: SÜRÜM KONTROLÜ İKİNCİ PATH D:\project\ten_minute\android\app\src\main\AndroidManifest.xml

final Controller_get cs = Get.put(Controller_get());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  cameras = await availableCameras();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var email = preferences.getString("email");
  cs.CurrentUserEmail = email.obs;

  ///-----------------reklam---------------------------------------///

  WidgetsFlutterBinding.ensureInitialized();
  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initFuture);

  ///-----------------reklam---------------------------------------///

  ///------------------in_app_purchase---------------------------------///
  InAppPurchaseConnection.enablePendingPurchases();

  ///------------------in_app_purchase---------------------------------///

  ///29 nisana camera widget ekranına bubble ekle :d
  ///28 nisan da record a basınca reklam gelsin bunu ayarla!!! istersen kelimelerin arasına da koyabilirsin reklam
  ///bence koymalısın :D https://www.youtube.com/watch?v=m0d_pbgeeG8 bu linkten ayarlarsın :D
  ///
  ///27 nisan da preview ve watch video screen deki hatayı düzelt//TODO:DONE :d
  ///hatanın sebebi animated splash screen knka :D
  ///video yu compress ettin :D TODO:DONE
  ///daha sonra watch videos a llery saver ekle// TODO:DONE
  ///reklam ekle!!!!!!!
  ///display my words error u na bak !!! TODO:DONE
  ///all words list i ve my words listte ki width leri ekrana oranla TODO:DONE
  ///kelime yazdırmayı tekrar gözden geçir cümle aldır !!!!! TODO:DONE
  ///en önemlisi bu şuan all words e bişey eklenip daha sonra boşaltılırsa error veriyor TODO:DONE
  ///çünkü içi bok gibi oldu adam akıllı baştan yazdırıp okut!!! 0 dan TODO: DONE
  ///giriş veya kayıt olma başarılı yönlendiriliyorsunuz yazısı ekle//TODO:DONE
  ///neredeyse tüm size ları MediaQuery.of(context).size.width*50/411 ile oranladın tekrar bunları gözden geçir 1 tane bile const size kalmasın!!!!!!!!!!!!!!

  runApp(ChangeNotifierProvider(
    create: (context) => ProviderModel(),
    child: Provider.value(
      value: adState,
      builder: (context, child) => GetMaterialApp(
        home: email == null ? welcome_screen() : days_screen(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  ));
}


