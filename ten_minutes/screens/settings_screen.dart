import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:ten_minute/consts.dart';
import 'package:ten_minute/controller.dart';
import 'package:ten_minute/providermodel.dart';
import 'package:ten_minute/screens/all_words_screen.dart';
import 'package:ten_minute/screens/days_screen.dart';
import 'package:ten_minute/screens/silat.dart';
import 'package:ten_minute/widgets/text_widgets.dart';

class settings_screen extends StatefulWidget {
  @override
  _settings_screenState createState() => _settings_screenState();
}

class _settings_screenState extends State<settings_screen> {
  ///------------in_app_purchase------------///

  ///------------in_app_purchase------------///

  var native_language = "native";
  var target_language = "target";
  bool show = false;

  final Controller_get cs = Get.put(Controller_get());

  Future<void> update_native_language({@required String mail, @required String asupdate}) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(mail)
        .update({"native_language": asupdate}).then((value) => print("native_language updated"));
  }

  Future<void> update_target_language({@required String mail, @required String asupdate}) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(mail)
        .update({"target_language": asupdate}).then((value) => print("target_language updated"));
  }

  Future<void> update_video_quality({@required String mail, @required String asupdate}) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(mail)
        .update({"video_quality": asupdate}).then((value) => print("video_quality updated"));
  }

  Future<void> update_premium_account({@required String mail, @required bool asupdate}) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(mail)
        .update({"premium": asupdate}).then((value) => print("premium_account updated"));
  }


  void show_stroge_toast({@required String message}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: colors().brown,
      textColor: colors().yellow,
      fontSize: MediaQuery.of(context).size.width * 16 / 411,
    );
  }

  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  @override
  void initState() {
    var provider = Provider.of<ProviderModel>(context, listen: false);
    provider.verifyPurchase();
    super.initState();
  }

  void _buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderModel>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: colors().grey_2,
        appBar: AppBar(
          backgroundColor: colors().brown,
          leading: BackButton(
            onPressed: () {
              Get.to(() => days_screen());
            },
          ),
          title: little_text_grey(title: "Settings", value: MediaQuery.of(context).size.width * 15 / 411),
        ),
        body: ModalProgressHUD(
          child: Container(
            color: colors().grey_2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.user,
                            size: MediaQuery.of(context).size.width * 150 / 411,
                            color: colors().yellow,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 250,
                                child: AutoSizeText(
                                  cs.CurrentUserEmail.toString(),
                                  style: TextStyle(
                                      color: colors().yellow, fontSize: MediaQuery.of(context).size.width * 30 / 411, fontFamily: "bahnschrift"),
                                  minFontSize: 1,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                "${cs.premium_account.toString() == "true" ? "PREMIUM ACCOUNT" : "NORMAL ACCOUNT"}",
                                style: TextStyle(color: colors().grey, fontSize: MediaQuery.of(context).size.width * 25 / 411),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.width * 3 / 411,
                      width: MediaQuery.of(context).size.width,
                      color: colors().grey,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: colors().brown),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.language,
                            color: colors().yellow,
                            size: MediaQuery.of(context).size.width * 40 / 411,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 1 / 20,
                          ),
                          Text(
                            "Native language:",
                            style:
                                TextStyle(color: colors().grey, fontSize: MediaQuery.of(context).size.width * 15 / 411, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 1 / 20,
                          ),
                          Dropdownmenu(
                            title: cs.native_language.toString() == "" ? "Select" : cs.native_language.toString(),
                            chosenValue: native_language,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 15 / 411,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: colors().brown),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.language,
                            color: colors().yellow,
                            size: MediaQuery.of(context).size.width * 40 / 411,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 1 / 20,
                          ),
                          Text(
                            "Target language:",
                            style:
                                TextStyle(color: colors().grey, fontSize: MediaQuery.of(context).size.width * 15 / 411, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 1 / 20,
                          ),
                          Dropdownmenu(
                            title: cs.target_language.toString() == "" ? "Select" : cs.target_language.toString(),
                            chosenValue: target_language,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 15 / 411,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: colors().brown),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.video,
                            color: colors().yellow,
                            size: MediaQuery.of(context).size.width * 40 / 411,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 1 / 18,
                          ),
                          Text(
                            "Video quality:",
                            style:
                                TextStyle(color: colors().grey, fontSize: MediaQuery.of(context).size.width * 15 / 411, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 1 / 20,
                          ),
                          dropdown_quality(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 15 / 411,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: colors().brown),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.tools,
                            color: colors().yellow,
                            size: MediaQuery.of(context).size.width * 40 / 411,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 1 / 18,
                          ),
                          Text(
                            "Reset words pages",
                            style:
                                TextStyle(color: colors().grey, fontSize: MediaQuery.of(context).size.width * 15 / 411, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 1 / 20,
                          ),
                          ElevatedButton(
                              child: button_text_yellow(title: "RESET", value: MediaQuery.of(context).size.width * 15 / 411),
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width * 30 / 411,
                                    right: MediaQuery.of(context).size.width * 30 / 411,
                                    top: MediaQuery.of(context).size.width * 8 / 411,
                                    bottom: MediaQuery.of(context).size.width * 8 / 411)),
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                backgroundColor: MaterialStateProperty.all<Color>(colors().brown),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 130 / 411),
                                    side: BorderSide(color: Colors.grey))),
                              ),
                              onPressed: () {
                                Alert(
                                  context: context,
                                  type: AlertType.warning,
                                  style: AlertStyle(
                                      backgroundColor: colors().brown,
                                      titleStyle: TextStyle(color: colors().grey, fontSize: MediaQuery.of(context).size.width * 20 / 411, fontFamily: "bahnschrift")),
                                  title: "Words pages will be reset. \n Are you sure?",
                                  buttons: [
                                    DialogButton(
                                        child: Text(
                                          "Do reset",
                                          style: TextStyle(
                                              color: colors().brown,
                                              fontSize: MediaQuery.of(context).size.width * 20 / 411,
                                              fontFamily: "bahnschrift"),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            show = true;
                                          });
                                          File(cs.all_word_path.toString())
                                              .delete()
                                              .whenComplete(() => File(cs.my_words_path.toString()).delete().whenComplete(() {
                                                    setState(() {
                                                      show = false;
                                                    });
                                                    show_stroge_toast(message: "Words pages reseted");
                                                  }));
                                        }),
                                    DialogButton(
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                              color: colors().brown,
                                              fontSize: MediaQuery.of(context).size.width * 20 / 411,
                                              fontFamily: "bahnschrift"),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        })
                                  ],
                                ).show();
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
                cs.premium_account.toString() == "false"
                    ? Column(
                        children: [
                          Container(
                            height: 3,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.green.shade700,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 1 / 7,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(color: colors().brown),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.dollarSign,
                                  color: Colors.green.shade600,
                                  size: MediaQuery.of(context).size.width * 60 / 411,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    little_text_yellow(title: "Buy premium account and get rid of ads", value: MediaQuery.of(context).size.width * 15 / 411),
                                    
                                    ElevatedButton(
                                        child: button_text_brown(title: "BUY", value: MediaQuery.of(context).size.width * 20 / 411),
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all<EdgeInsets>(
                                              EdgeInsets.only(left: MediaQuery.of(context).size.width * 80 / 411, right: MediaQuery.of(context).size.width * 80 / 411, top: MediaQuery.of(context).size.width * 10 / 411, bottom: MediaQuery.of(context).size.width * 10 / 411)),
                                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                          backgroundColor: MaterialStateProperty.all<Color>(colors().yellow),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 130 / 411), side: BorderSide(color: Colors.grey))),
                                        ),
                                        onPressed: () {
                                          for (var prod in provider.products) {
                                            _buyProduct(prod);
                                            
                                            if (provider.hasPurchased(prod.id) != null){
                                              update_premium_account(mail: cs.CurrentUserEmail.toString(), asupdate: true);
                                            }
                                          }
                                        }),
                                    little_text_yellow(title: "Thanks for your support", value: MediaQuery.of(context).size.width * 15 / 411),
                                  ],
                                ),
                                FaIcon(
                                  FontAwesomeIcons.dollarSign,
                                  color: Colors.green.shade600,
                                  size: MediaQuery.of(context).size.width * 60 / 411,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.width * 3 / 411,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.green.shade700,
                          ),
                        ],
                      )
                    : Container(),
                Column(
                  children: [
                    ElevatedButton(
                        child: button_text_yellow(title: "Save", value: MediaQuery.of(context).size.width * 20 / 411),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 80 / 411,
                              right: MediaQuery.of(context).size.width * 80 / 411,
                              top: MediaQuery.of(context).size.width * 10 / 411,
                              bottom: MediaQuery.of(context).size.width * 10 / 411)),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(colors().brown),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 130 / 411),
                              side: BorderSide(color: Colors.grey))),
                        ),
                        onPressed: () {
                          setState(() {
                            show = true;
                          });
                          print(cs.target_language.toString());
                          print(cs.native_language.toString());
                          print(cs.video_quality.toString());
                          update_native_language(mail: cs.CurrentUserEmail.toString(), asupdate: cs.native_language.toString()).whenComplete(() {
                            update_target_language(mail: cs.CurrentUserEmail.toString(), asupdate: cs.target_language.toString()).whenComplete(() {
                              update_video_quality(mail: cs.CurrentUserEmail.toString(), asupdate: cs.video_quality.toString()).whenComplete(() {
                                setState(() {
                                  show = false;
                                });
                                show_stroge_toast(message: "Saved");
                              });
                            });
                          });
                        }),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 20 / 411,
                    ),
                  ],
                ),
              ],
            ),
          ),
          inAsyncCall: show,
        ),
      ),
    );
  }
}

class Dropdownmenu extends StatefulWidget {
  var chosenValue;
  final String title;

  Dropdownmenu({@required this.chosenValue, @required this.title});

  @override
  _DropdownmenuState createState() => _DropdownmenuState(chosenValue: chosenValue, title: title);
}

class _DropdownmenuState extends State<Dropdownmenu> {
  String _value;
  var chosenValue;
  final String title;
  final Controller_get cs = Get.put(Controller_get());

  _DropdownmenuState({@required this.chosenValue, @required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0.0),
      child: DropdownButton(
        underline: Container(
          color: colors().yellow,
          height: MediaQuery.of(context).size.width * 2 / 411,
        ),
        value: _value,
        style: TextStyle(color: colors().grey, fontSize: MediaQuery.of(context).size.width * 20 / 411, fontFamily: "bahnschrift"),
        items: [
          DropdownMenuItem(
            child: Text("Turkish <3"),
            value: "tr",
          ),
          DropdownMenuItem(
            child: Text("Afrikaans"),
            value: "af",
          ),
          DropdownMenuItem(
            child: Text("Arabic"),
            value: "ar",
          ),
          DropdownMenuItem(
            child: Text("Azeri <3"),
            value: "az",
          ),
          DropdownMenuItem(
            child: Text("Belarusian"),
            value: "be",
          ),
          DropdownMenuItem(
            child: Text("Bulgarian"),
            value: "bg",
          ),
          DropdownMenuItem(
            child: Text("Catalan"),
            value: "ca",
          ),
          DropdownMenuItem(
            child: Text("Czech"),
            value: "cs",
          ),
          DropdownMenuItem(
            child: Text("welsh"),
            value: "cy",
          ),
          DropdownMenuItem(
            child: Text("Danish"),
            value: "da",
          ),
          DropdownMenuItem(
            child: Text("German"),
            value: "de",
          ),
          DropdownMenuItem(
            child: Text("Divehi"),
            value: "dv",
          ),
          DropdownMenuItem(
            child: Text("Greek"),
            value: "el",
          ),
          DropdownMenuItem(
            child: Text("English"),
            value: "en",
          ),
          DropdownMenuItem(
            child: Text("Spanish"),
            value: "es",
          ),
          DropdownMenuItem(
            child: Text("Estonian"),
            value: "et",
          ),
          DropdownMenuItem(
            child: Text("Basque"),
            value: "eu",
          ),
          DropdownMenuItem(
            child: Text("Farsi"),
            value: "fa",
          ),
          DropdownMenuItem(
            child: Text("Finnish"),
            value: "fi",
          ),
          DropdownMenuItem(
            child: Text("Faroese"),
            value: "fo",
          ),
          DropdownMenuItem(
            child: Text("French"),
            value: "fr",
          ),
          DropdownMenuItem(
            child: Text("Galician"),
            value: "gl",
          ),
          DropdownMenuItem(
            child: Text("Gujarati"),
            value: "gu",
          ),
          DropdownMenuItem(
            child: Text("Hebrew"),
            value: "he",
          ),
          DropdownMenuItem(
            child: Text("Hindi"),
            value: "hi",
          ),
          DropdownMenuItem(
            child: Text("Croatian"),
            value: "hr",
          ),
          DropdownMenuItem(
            child: Text("Hungarian"),
            value: "hu",
          ),
          DropdownMenuItem(
            child: Text("Armenian"),
            value: "hy",
          ),
          DropdownMenuItem(
            child: Text("Indonesian"),
            value: "id",
          ),
          DropdownMenuItem(
            child: Text("Icelandic"),
            value: "is",
          ),
          DropdownMenuItem(
            child: Text("Itelian"),
            value: "it",
          ),
          DropdownMenuItem(
            child: Text("Japanese"),
            value: "ja",
          ),
          DropdownMenuItem(
            child: Text("Georgian"),
            value: "ka",
          ),
          DropdownMenuItem(
            child: Text("Kazakh"),
            value: "kk",
          ),
          DropdownMenuItem(
            child: Text("Korean"),
            value: "ko",
          ),
          DropdownMenuItem(
            child: Text("Kyrgyz"),
            value: "ky",
          ),
          DropdownMenuItem(
            child: Text("Lithuanian"),
            value: "lt",
          ),
          DropdownMenuItem(
            child: Text("Latvian"),
            value: "lv",
          ),
          DropdownMenuItem(
            child: Text("Dutch"),
            value: "nl",
          ),
          DropdownMenuItem(
            child: Text("Polish"),
            value: "pl",
          ),
          DropdownMenuItem(
            child: Text("Portuguese"),
            value: "pt",
          ),
          DropdownMenuItem(
            child: Text("Romanian"),
            value: "ro",
          ),
          DropdownMenuItem(
            child: Text("Russian"),
            value: "ru",
          ),
          DropdownMenuItem(
            child: Text("Slovak"),
            value: "sk",
          ),
          DropdownMenuItem(
            child: Text("Slovenian"),
            value: "sl",
          ),
          DropdownMenuItem(
            child: Text("Albanian"),
            value: "sq",
          ),
          DropdownMenuItem(
            child: Text("Swedish"),
            value: "sv",
          ),
          DropdownMenuItem(
            child: Text("Syriac"),
            value: "syr",
          ),
          DropdownMenuItem(
            child: Text("Tamil"),
            value: "ta",
          ),
          DropdownMenuItem(
            child: Text("Telugu"),
            value: "te",
          ),
          DropdownMenuItem(
            child: Text("Thai"),
            value: "th",
          ),
          DropdownMenuItem(
            child: Text("Tagalog"),
            value: "tl",
          ),
          DropdownMenuItem(
            child: Text("Tswana"),
            value: "tn",
          ),
          DropdownMenuItem(
            child: Text("Tatar"),
            value: "tt",
          ),
          DropdownMenuItem(
            child: Text("Tsonga"),
            value: "ts",
          ),
          DropdownMenuItem(
            child: Text("Ukrainian"),
            value: "uk",
          ),
          DropdownMenuItem(
            child: Text("Urdu"),
            value: "ur",
          ),
          DropdownMenuItem(
            child: Text("Uzbek"),
            value: "uz",
          ),
          DropdownMenuItem(
            child: Text("Vietnamese"),
            value: "vi",
          ),
          DropdownMenuItem(
            child: Text("Chinese"),
            value: "zh",
          ),
          DropdownMenuItem(
            child: Text("Zulu"),
            value: "zu",
          ),
        ],
        hint: Text(
          title,
          style: TextStyle(color: colors().grey, fontSize: MediaQuery.of(context).size.width * 16 / 411, fontWeight: FontWeight.w500),
        ),
        onChanged: (value) {
          setState(() {
            _value = value;
            if (chosenValue == "target") {
              cs.target_language = _value.obs;
            } else if (chosenValue == "native") {
              cs.native_language = _value.obs;
            }
          });
        },
      ),
    );
  }
}

class dropdown_quality extends StatefulWidget {
  @override
  _dropdown_qualityState createState() => _dropdown_qualityState();
}

class _dropdown_qualityState extends State<dropdown_quality> {
  String chosenValue;
  final Controller_get cs = Get.put(Controller_get());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0.0),
      child: DropdownButton<String>(
        value: chosenValue,
        underline: Container(
          color: colors().yellow,
          height: 2,
        ),
        style: TextStyle(color: colors().brown, fontSize: MediaQuery.of(context).size.width * 20 / 411, fontFamily: "bahnschrift"),
        items: <String>["high", "low", "medium", "default"].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(color: colors().grey),
            ),
          );
        }).toList(),
        hint: Text(
          cs.video_quality.toString(),
          style: TextStyle(color: colors().grey, fontSize: MediaQuery.of(context).size.width * 16 / 411, fontWeight: FontWeight.w500),
        ),
        onChanged: (String value) {
          setState(() {
            chosenValue = value;
            cs.video_quality = chosenValue.obs;
          });
        },
      ),
    );
  }
}
