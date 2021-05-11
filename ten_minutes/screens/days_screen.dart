import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connection_status_bar/connection_status_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ten_minute/ad_state.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:ten_minute/consts.dart';
import 'package:ten_minute/controller.dart';
import 'package:ten_minute/providermodel.dart';
import 'package:ten_minute/screens/settings_screen.dart';
import 'package:ten_minute/widgets/button_widgets.dart';
import 'package:ten_minute/widgets/text_widgets.dart';
import 'package:ten_minute/screens/all_words_screen.dart';
import 'package:ten_minute/screens/my_videos.dart';
import 'package:ten_minute/screens/my_words_screen.dart';
import 'package:ten_minute/screens/welcome_screen.dart';
import 'package:showcaseview/showcaseview.dart';

class days_screen extends StatefulWidget {
  final Controller_get cs = Get.put(Controller_get());

  @override
  _days_screenState createState() => _days_screenState();
}

PublisherInterstitialAd myInterstitial;

class _days_screenState extends State<days_screen> {
  bool show = true;

  ///----------------banner---------------------///
  
  BannerAd banner;

  ///----------------banner---------------------///


  ///-----------------bildirim-------------------------------------///

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Duration next_day_time;


  ///-----------------bildirim------------------------------------///


  ///-----------show case key items-----------------///
  final keyone = GlobalKey();
  final keytwo = GlobalKey();
  final keythree = GlobalKey();
  final keyfour = GlobalKey();
  final keyfive = GlobalKey();
  final keysix = GlobalKey();
  final keyseven = GlobalKey();
  final keyeight = GlobalKey();
  final keynine = GlobalKey();
  final keyten = GlobalKey();

  
  ///-----------show case key items-----------------///

  Future<void> update_first_enter({@required String mail}) async {
    return FirebaseFirestore.instance.collection("users").doc(mail).update({"first_enter": false}).then((value) => print("first_enter updated"));
  }

  Future<void> update_is_recorded_today() async {
    var info = await FlutterVideoInfo().getVideoInfo(
        "/storage/emulated/0/Android/data/burakatalay.ten_minute/files/${cs.CurrentUserEmail.toString()}_${cs.day_calculator.toString()}.mp4");
    print("day:${cs.day_calculator.toString()}");
    print("file_size:${info.filesize}");
    if (info.filesize == 0) {
      setState(() {
        FirebaseFirestore.instance
            .collection("users")
            .doc(cs.CurrentUserEmail.toString())
            .update({"is_recorded_today": false}).then((value) => print("is_recorded_today updated"));
      });
    } else
      setState(() {
        FirebaseFirestore.instance
            .collection("users")
            .doc(cs.CurrentUserEmail.toString())
            .update({"is_recorded_today": true}).then((value) => print("is_recorded_today updated"));
      });
  }

  ///-------------------words text doc file--------------------------///


  Future<String> get _localpath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localpath;
    cs.my_words_path = File("$path/${cs.CurrentUserEmail.toString()}_my_words.txt").path;
    cs.all_word_path = File("$path/${cs.CurrentUserEmail.toString()}_all_words.txt").path;
    print(cs.all_word_path);
    print(cs.my_words_path);
  }




  ///-------------------words text doc file--------------------------///

  Future<void> get_info_firebase() async {
    await FirebaseFirestore.instance.collection('users').doc(cs.CurrentUserEmail.toString()).get().then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        var date = await documentSnapshot.get("registry_date");
        int year = date[0];
        int month = date[1];
        int day = date[2];
        int hour = date[3];
        int minute = date[4];

        bool enter = documentSnapshot.get("first_enter");
        cs.first_signin = enter.obs;

        bool premium = documentSnapshot.get("premium");
        cs.premium_account = premium.obs;

        var native_lang = documentSnapshot.get("native_language");
        cs.native_language = native_lang.toString().obs;

        var target_lang = documentSnapshot.get("target_language");
        cs.target_language = target_lang.toString().obs;

        var video_quality = documentSnapshot.get("video_quality");
        cs.video_quality = video_quality.toString().obs;

        bool recorded = documentSnapshot.get("is_recorded_today");
        cs.is_recorded_today = recorded.obs;

        var birthday = await DateTime(year, month, day, hour, minute);
        var date2 = DateTime.now();

        var difference = await date2.difference(birthday).inDays;

        setState(() {
                  cs.day_calculator = (difference + 1).obs;
                });
        int date4 = difference + 1;
        var date3 = birthday.add(Duration(
          days: date4,
        ));

        var diffirence_2 = await "${date3.difference(date2)}";
        cs.when_record = await "${diffirence_2.substring(0, 8)}";

        next_day_time = date3.difference(date2);

        cs.registry_year = year.obs;
        cs.registry_month = month.obs;
        cs.registry_day = day.obs;
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  void show_spinner() {
    setState(() {
      if (cs.day_calculator.toString() == "0") {
        show = true;
      } else
        show = false;
    });
  }


  
  Future _showNotification()async{
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false);
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    
    var scheduledTime_noti = DateTime.now().add(Duration(seconds: 5));
    flutterLocalNotificationsPlugin.schedule(1, "Ten minutes", "Last ${next_day_time.inHours.toString()} hours. Don't break the chain!", scheduledTime_noti, platformChannelSpecifics);
  }


  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    
    await Navigator.push(
      context,
      
      MaterialPageRoute<void>(builder: (context) => days_screen()),
    );
}




  @override
  void initState() {
    super.initState();
    var androidInitilize = AndroidInitializationSettings('screen');
    var initilizationsSettings = InitializationSettings(android: androidInitilize);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initilizationsSettings,onSelectNotification: selectNotification);
    
    ///----------------in_app_purchase-------------------///
    var provider = Provider.of<ProviderModel>(context, listen:false);
    provider.initialize();
    ///----------------in_app_purchase-------------------///


    _localFile;
    setState(() {
      get_info_firebase().then((value) {
        show_spinner();
        update_is_recorded_today();
        if(cs.first_signin.toString()=="true"){
        WidgetsBinding.instance.addPostFrameCallback(
                (_)=> ShowCaseWidget.of(scaffoldkey.currentContext).startShowCase([keyone,keytwo,keythree,keyfour,keyfive,keysix,keyseven,keyeight,keynine,keyten]),
        );
        update_first_enter(mail: cs.CurrentUserEmail.toString());
        }else{
          return;
        }

      }).then((value) {
        notifivation_schedule();
    });
    });
  }

  @override
    void dispose() {
      
      var provider = Provider.of<ProviderModel>(context, listen:false);
      provider.subscription.cancel();

      super.dispose();
    }



  void notifivation_schedule()async{
        if (await cs.is_recorded_today.toString()=="false") {
          if (next_day_time < Duration(hours: 10) && next_day_time > Duration(hours:1)) {
            _showNotification();
            print("notification 10");
            Future.delayed(Duration(hours: 4),(){
              if (cs.is_recorded_today.toString()=="false") {
                _showNotification();
                print("notification 5");
                Future.delayed(Duration(hours: 3),(){
                  if (cs.is_recorded_today.toString()=="false") {
                    _showNotification();
                    print("notification 2");
                    Future.delayed(Duration(hours: 2),(){
                      if (cs.is_recorded_today.toString()=="false") {
                        _showNotification();
                        print("notification 0");
                      }else{
                        return;
                      }
                    });
                  }else{
                    return;
                  }
                });
              } else {
                return;
              }
            }
            );
          } else {
            return;
          }
        } else {
          return
          print("bildirime gerek yok bügün kaydetmiş");
        }
  }


  @override
    void didChangeDependencies() {
      super.didChangeDependencies();
      final adState = Provider.of<AdState>(context);
      adState.initialization.then((status){
        setState(() {
          banner = BannerAd(
            adUnitId: adState.bannerAdUnitId,
            size: AdSize.banner,
            request: AdRequest(),
            listener: adState.adListener,
          )..load();
          
          myInterstitial = PublisherInterstitialAd(
            adUnitId: adState.videoad,
            request: PublisherAdRequest(),
            listener: AdListener(),
          )..load();
        });
      });
    }


  final scaffoldkey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:ShowCaseWidget(
        builder: Builder(builder: (context)=>Scaffold(
          key: scaffoldkey,
          backgroundColor: colors().grey,
          appBar: AppBar(
            backgroundColor: colors().brown,
            title: little_text_grey(title: "10 MINUTES", value: MediaQuery.of(context).size.width*20/411),
            leading: CustomShowcaseWidget(
              description: "Tap here to learn how to use 10 minutes.",title:"MENU",globalKey: keyfour,
              child: IconButton(
                  icon: FaIcon(FontAwesomeIcons.bars),onPressed:(){scaffoldkey.currentState.openDrawer();}),
            ),
          ),
          drawer: Drawer(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/walk.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/logo.png"),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width*3/411,
                    child: Container(
                      color: colors().brown,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width*47/411,
                  ),
                  ListTile(
                    selectedTileColor: Colors.yellow,
                    leading: CustomShowcaseWidget(
                      globalKey: keyfive,
                      title: "All words",description: "You can add native language words to this list while recording a video.",
                      child: FaIcon(
                        FontAwesomeIcons.solidListAlt,
                        color: colors().yellow,
                      ),
                    ),
                    title: little_text_yellow(title: "Words", value:MediaQuery.of(context).size.width*20/411),
                    subtitle: Text(
                      "All words",
                      style: TextStyle(color: colors().grey),
                    ),
                    onTap: () {
                      if(cs.native_language.toString() == "" || cs.target_language.toString()==""){
                        Alert(
                          context: context,
                          type: AlertType.info,
                          style: AlertStyle(backgroundColor: colors().brown, titleStyle: TextStyle(color: colors().grey, fontSize: MediaQuery.of(context).size.width*20/411, fontFamily: "bahnschrift")),
                          title: "You need to choose any language \n Go to settings page",
                          buttons: [
                            DialogButton(
                              child: Text(
                                "Go",
                                style: TextStyle(color: colors().brown, fontSize: MediaQuery.of(context).size.width*20/411, fontFamily: "bahnschrift"),
                              ),
                            onPressed: () => Get.to(()=>settings_screen()),
                          color: colors().yellow,
                          radius: BorderRadius.circular(MediaQuery.of(context).size.width*20/411),
                            ),
                          ],
                        ).show();
                      }else{
                        Get.to(() => all_words());
                      }
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width*1/411,
                    child: Container(
                      color: colors().grey,
                    ),
                  ),
                  ListTile(
                    selectedTileColor: Colors.yellow,
                    leading: CustomShowcaseWidget(
                      globalKey: keysix,
                      title: "My words",description: "If you click display my words while recording a video, you can see the words in this list on your screen.",
                      child: FaIcon(
                        FontAwesomeIcons.chalkboardTeacher,
                        color: colors().yellow,
                      ),
                    ),
                    title: little_text_yellow(title: "My words", value:MediaQuery.of(context).size.width*20/411),
                    subtitle: Text(
                      "Words to display in videos",
                      style: TextStyle(color: colors().grey),
                    ),
                    onTap: () {
                      if(cs.native_language.toString() == "" || cs.target_language.toString()==""){
                        Alert(
                          context: context,
                          type: AlertType.info,
                          style: AlertStyle(backgroundColor: colors().brown, titleStyle: TextStyle(color: colors().grey, fontSize:MediaQuery.of(context).size.width*20/411, fontFamily: "bahnschrift")),
                          title: "You need to choose any language \n Go to settings page",
                          buttons: [
                            DialogButton(
                              child: Text(
                                "Go",
                                style: TextStyle(color: colors().brown, fontSize: MediaQuery.of(context).size.width*20/411, fontFamily: "bahnschrift"),
                              ),
                            onPressed: (){ 
                              setState(() {
                                Get.to(()=>settings_screen()).whenComplete(() => Navigator.pop(context));
                              });
                            },
                          color: colors().yellow,
                          radius: BorderRadius.circular(MediaQuery.of(context).size.width*20/411),
                            ),
                          ],
                        ).show();
                      }else{
                        Get.to(() => my_words());
                      }
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width*1/411,
                    child: Container(
                      color: colors().grey,
                    ),
                  ),
                  ListTile(
                    selectedTileColor: Colors.yellow,
                    leading: CustomShowcaseWidget(
                      globalKey: keyseven,title: "My videos",description: "Your recorded videos are stored in this section. You can watch or delete your videos.",
                      child: FaIcon(
                        FontAwesomeIcons.video,
                        color: colors().yellow,
                      ),
                    ),
                    title: little_text_yellow(title: "My videos", value:MediaQuery.of(context).size.width*20/411),
                    subtitle: Text(
                      "Videos you recorded",
                      style: TextStyle(color: colors().grey),
                    ),
                    onTap: () {
                      Get.to(() => my_videos());
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width*1/411,
                    child: Container(
                      color: colors().grey,
                    ),
                  ),
                  ListTile(
                    selectedTileColor: Colors.yellow,
                    leading: CustomShowcaseWidget(
                      globalKey: keyeight,title: "Settings",description: "You can set your video quality, your native language and target language",
                      child: FaIcon(
                        FontAwesomeIcons.cog,
                        color: colors().yellow,
                      ),
                    ),
                    title: little_text_yellow(title: "Settings", value: MediaQuery.of(context).size.width*20/411),
                    subtitle: Text(
                      "Languages and video quality settings",
                      style: TextStyle(color: colors().grey),
                    ),
                    onTap: () {
                      Get.to(() => settings_screen());
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width*1/411,
                    child: Container(
                      color: colors().grey,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width*175/411,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width*1/411,
                    child: Container(
                      color: colors().yellow,
                    ),
                  ),
                  ListTile(
                    selectedTileColor: Colors.yellow,
                    leading: CustomShowcaseWidget(globalKey: keynine,title: "User",description: "The account you logged in. If you want to support me, you can purchase a premium account.",
                      child: FaIcon(
                        FontAwesomeIcons.user,
                        color: colors().yellow,
                      ),
                    ),
                    title: AutoSizeText(
                      cs.CurrentUserEmail.toString(),
                      style: TextStyle(color: colors().yellow, fontSize:MediaQuery.of(context).size.width*12/411, fontFamily: "bahnschrift"),
                      minFontSize: 10,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      "${cs.premium_account.toString() == "true" ? "PREMIUM ACCOUNT" : "NORMAL ACCOUNT"}",
                      style: TextStyle(color: colors().grey),
                    ),
                    onTap: () {},
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width*1/411,
                    child: Container(
                      color: colors().yellow,
                    ),
                  ),
                  ListTile(
                    selectedTileColor: Colors.yellow,
                    leading: CustomShowcaseWidget(globalKey: keyten,
                      title: "Logout",description: "To log out from ten minutes app you can tap here. The app supports multiple accounts.",
                      child: FaIcon(
                        FontAwesomeIcons.doorClosed,
                        color: Colors.grey,
                      ),
                    ),
                    title: Text(
                      'Logout',
                      style: TextStyle(fontSize: MediaQuery.of(context).size.width*20/411, color: Colors.grey),
                    ),
                    onTap: () async {
                      SharedPreferences preferences = await SharedPreferences.getInstance();
                      if (googleSignIn.currentUser != null) {
                        await googleSignIn.disconnect().then((value) {
                          cs.CurrentUserEmail = "".obs;
                          googleSignIn.signOut().then((value) => Get.to(() => welcome_screen()));
                        });
                      } else if (auth.currentUser != null) {
                        cs.CurrentUserEmail = "".obs;
                        preferences.remove("email");
                        print(cs.CurrentUserEmail);
                        print(googleSignIn.currentUser);

                        await auth.signOut().then((value) => Get.to(() => welcome_screen()));
                      } else
                        Get.to(() => welcome_screen());
                    },
                  ),
                ],
              ),
            ),
          ),
          body: ModalProgressHUD(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/tree.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: ConnectionStatusBar(),
                        ),
                        CustomShowcaseWidget(
                          title: "Date",description: "Date of today", globalKey: keyone,
                          child: AutoSizeText(
                            "${DateTime.now().day}.${DateTime.now().month.toString().length == 1 ? "0" : ""}${DateTime.now().month}.${DateTime.now().year}",
                            style: TextStyle(color: colors().grey,
                                fontSize: MediaQuery.of(context).size.width*70/411,
                                fontFamily: "bahnschrift"),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: CustomShowcaseWidget(
                      globalKey: keytwo,
                      title: "COUNTER",description: "Number of days since you downloaded the app.",
                      child: AutoSizeText(
                        "#${cs.day_calculator.toString()}",
                        style: TextStyle(
                            color: cs.is_recorded_today.toString() == "false" ? colors().grey_2 : colors().yellow, fontSize:MediaQuery.of(context).size.width*300/411, fontFamily: "bahnschrift"),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        minFontSize: 100,
                      ),
                    ),
                  ),
                  Expanded(
                      child: CustomShowcaseWidget(
                        globalKey: keythree,
                        title: "RECORD BUTTON",description: "You can record videos by clicking this button. You can delete your old videos and record a new one if you wish.",
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            button_full_record(title: "Record", context: context),
                          ],
                        ),
                      ),),
                  banner == null || cs.premium_account.toString()=="true"?SizedBox(height: MediaQuery.of(context).size.width*50/411,):Container(height: MediaQuery.of(context).size.width*50/411,child: AdWidget(ad: banner,),
                  ),                    
                ],
              ),
            ),
            inAsyncCall: show,
          ),
        ),),
      ),
    );
  }
}
class CustomShowcaseWidget extends StatelessWidget {
  final Widget child;
  final String description;
  final String title;
  final GlobalKey globalKey;


  const CustomShowcaseWidget({
    @required this.description,
    @required this.title,
    @required this.child,
    @required this.globalKey,

});
  @override
  Widget build(BuildContext context) =>
    Showcase(
      key: globalKey,
      showcaseBackgroundColor: colors().yellow,
      contentPadding: EdgeInsets.all(12),
      title: title,
      description: description,
      descTextStyle: TextStyle(color: Colors.brown, fontSize: 20, fontFamily: "bahnschrift"),
      child: child,
    );

}


