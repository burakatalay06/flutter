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


