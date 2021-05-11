import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:ten_minute/ad_state.dart';
import 'package:ten_minute/screens/my_words_screen.dart';
import 'package:translator/translator.dart';

import 'package:ten_minute/consts.dart';
import 'package:ten_minute/main.dart';
import 'package:ten_minute/widgets/text_widgets.dart';
import 'days_screen.dart';
import 'package:ten_minute/controller.dart';


bool show = true;
List all_word_list = [];
List translated_words_list = [];

class all_words extends StatefulWidget {
  final Controller_get cs = Get.put(Controller_get());

  @override
  _all_wordsState createState() => _all_wordsState();
}

class _all_wordsState extends State<all_words> {

    Future<File> write_words(String all_words_str) async {
    final file = await File(cs.my_words_path.toString());
    return file.writeAsString("$all_words_str", mode: FileMode.append);
  }


  void show_toast({@required String message}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: colors().brown,
      textColor: colors().yellow,
      fontSize: 16.0,
    );
  }



  void show_alert() {
    Alert(
      context: context,
      type: AlertType.info,
      style: AlertStyle(backgroundColor: colors().brown, titleStyle: TextStyle(color: colors().grey, fontSize: MediaQuery.of(context).size.width*25/411, fontFamily: "bahnschrift")),
      title: "You haven't any word",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: colors().brown, fontSize: MediaQuery.of(context).size.width*25/411, fontFamily: "bahnschrift"),
          ),
          onPressed: () => Get.to(() => days_screen()),
          color: colors().yellow,
          radius: BorderRadius.circular(MediaQuery.of(context).size.width*20/411),
        ),
      ],
    ).show();
  }



  Future<int> read_word() async {
    try {
      final file = await File(cs.all_word_path.toString());
      String file_2 = await file.readAsString();
      if (file.isBlank || file_2.length == 0) {
        print("kelime yok");
      } else {
        String contents = await file.readAsString();
        print(contents);
        contents = await  contents.substring(0, contents.length-1);
        print(contents);
        all_word_list = await contents.split(", ");

        var _list_str = await all_word_list[0].toString();
        if (_list_str.length == 0) {
          show_alert();
        } else {
          var _repair_list =  _list_str;
          var _repair_list_2 = "[${_repair_list}]";

          var _repair_list_3 = json.decode(_repair_list_2);
          all_word_list = _repair_list_3;
          print(all_word_list);
          setState(() {
            all_word_list = _repair_list_3;
          });
        }
      }
    } on FileSystemException catch (e) {
      print(e.osError);
      if (e.osError.errorCode == 2) {
        show_alert();
      }
    }
  }

  void delete_words({@required String word}) async {
    setState(() {
      all_word_list.remove(word);
    });

    List list_2 = [];
    var value;
    final file = await File(cs.all_word_path.toString());
    await file.readAsString().then((value_2) {
      value = value_2;
    });
    List list = value.split(",");
    list.forEach((element) {
      if (element != "") {
        String element_2 = element.toString();
        String element_3 = element_2.substring(1, element_2.length - 1);
        print(element_3);
        list_2.add(element_3);
      }
    });
    list_2.remove(word);
    print(list_2);
    file.writeAsString("");
    for (var i in list_2) {
      i = '"$i",';
      print(i);
      await file.writeAsString(i, mode: FileMode.append);
    }
  }

  void make_translate_list({@required list}) async {
    try {
      if (File(cs.all_word_path.toString()).isBlank) {
        print("file is blank");
      } else {
        GoogleTranslator translator = GoogleTranslator();
         for (var i in list) {
          await translator.translate(i.toString(), from: cs.native_language.toString(), to: cs.target_language.toString()).then((value) {
            translated_words_list.add(value);
          });
          i = "";
        }
        setState(() {
          show = false;
          translated_words_list;
          print(translated_words_list);
        });
      }
    } catch (e) {
      print(e);
    }
  }



  @override
  void initState() {
    super.initState();
    setState(() {
      read_word().whenComplete(() {
        make_translate_list(list: all_word_list);
        
      });
    });
  }









  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ModalProgressHUD(
        inAsyncCall: show,
        child: Scaffold(
          backgroundColor: colors().grey,
          appBar: AppBar(
            leading: BackButton(
              onPressed: () {
                setState(() {
                  translated_words_list = [];
                  all_word_list = [];
                  Get.to(() => days_screen());
                  show = true;
                });
              },
            ),
            title: little_text_grey(title: "All words", value: MediaQuery.of(context).size.width * 15 / 411),
            actions: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.language,
                    color: colors().grey,
                  ),
                  little_text_grey(
                      title: "${cs.native_language.toString()} to ${cs.target_language.toString()}",
                      value: MediaQuery.of(context).size.width * 15 / 411),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width*1/15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.solidListAlt,
                        color: colors().grey,
                      ),
                      onPressed: () {
                        translated_words_list = [];
                        all_word_list = [];
                        show = true;
                        Get.to(() => my_words()).whenComplete(() => Navigator.of(context).pop());
                      }),
                  Text(
                    "My words",
                    style: TextStyle(color: colors().grey, fontSize: MediaQuery.of(context).size.width*6/411),
                  ),
                ],
              )
            ],
            backgroundColor: colors().brown,
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: all_word_list.length == 0 ? 0 : all_word_list.length,
                  separatorBuilder: (BuildContext context, int index) => Divider(),
                  itemBuilder: (context, index) {
                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              color: colors().brown,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: MediaQuery.of(context).size.width*87/411,
                                  minHeight: MediaQuery.of(context).size.width*87/411,
                                ),
                                child: Center(
                                  child: AutoSizeText(
                                    '${all_word_list[index]}',
                                    style: TextStyle(color: colors().yellow, fontSize: MediaQuery.of(context).size.width*30/411, fontFamily: "bahnschrift"),
                                    minFontSize: 10,
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: colors().grey_2,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: MediaQuery.of(context).size.width*87/411,
                                  minHeight: MediaQuery.of(context).size.width*87/411,
                                ),
                                child: Center(
                                  child: AutoSizeText(
                                    ////----------------------------------------------------------------------------
                                    translated_words_list.length > 0 ? translated_words_list[index].toString() : "loading...",
                                    style: TextStyle(color: colors().grey, fontSize: MediaQuery.of(context).size.width*30/411, fontFamily: "bahnschrift"),
                                    minFontSize: 10,
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        IconSlideAction(
                          onTap: (){
                            setState(() {
                              write_words('"${all_word_list[index].toString()}",').whenComplete(() =>delete_words(word: all_word_list[index]));
                              show_toast(message: "added to my words");
                              translated_words_list.remove(translated_words_list[index]);

                            });

                          },
                          caption: 'My words',
                          color: colors().grey_2,
                          icon: Icons.add,
                        ),
                      ],
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          onTap: (){
                            setState(() {
                              delete_words(word: all_word_list[index]);
                              translated_words_list.remove(translated_words_list[index]);
                              show_toast(message: "deleted");
                            });
                          },
                          caption: 'Delete',
                          color: Colors.red,
                          icon: Icons.delete,
                        ),
                      ],
                    );
                  },
                ),
              ),
            BannerAdWidget(AdSize.banner) == null || cs.premium_account.toString()=="true"?Container(height: 50
            ):BannerAdWidget(AdSize.banner),
            ],
          ),
        ),
      ),
    );
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