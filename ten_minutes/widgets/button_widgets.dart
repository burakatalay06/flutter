import 'dart:convert';
import 'dart:io';

import 'dart:math';

//-------firebase----------------------------------------///
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ten_minute/consts.dart';
import 'package:ten_minute/controller.dart';
import 'package:ten_minute/screens/all_words_screen.dart';
import 'package:ten_minute/screens/creat_account_screen.dart';
import 'package:ten_minute/screens/days_screen.dart';
import 'package:ten_minute/screens/settings_screen.dart';
import 'package:ten_minute/screens/sign_in_screen.dart';
import 'package:ten_minute/screens/sign_up_with_email_screen.dart';
import 'package:ten_minute/screens/watch_videos_screen.dart';
import 'camera_widget.dart';
import 'text_input_widgets.dart';
import 'text_widgets.dart';
//-------firebase----------------------------------------///

final Controller_get cs = Get.put(Controller_get());

///---------------------------------------firebase------------------------------------------///
///auth.currentUser.email mail ile giriş yapanın kimliği
///cs.CurrentUserMail giriş yapan kişinin mail adresi
GoogleSignIn googleSignIn = GoogleSignIn();
final auth = FirebaseAuth.instance;
String email = "";
String password = "";
var words_all = "";
String CurrentUserMail = "";



///---------------------------------------firebase------------------------------------------///
///
///
  Future<File> write_words(String all_words_str) async {
    final file = await File(cs.all_word_path.toString());
    return file.writeAsString("$all_words_str", mode: FileMode.append);
    }

///20=MediaQuery.of(context).size.height*5/219
///24=MediaQuery.of(context).size.height*2/73


  void show_toast({@required String message,@required context}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: colors().brown,
      textColor: colors().yellow,
      fontSize: MediaQuery.of(context).size.width*16/411,
    );
  }

Widget button_empty_sign_in({@required String title,@required context}) {
  return TextButton(
    child: Text(
      title,
      style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width*20/411, fontFamily: "bahnschrift"),
    ),
    style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(left: MediaQuery.of(context).size.width*130/411, right: MediaQuery.of(context).size.width*130/411, top: MediaQuery.of(context).size.width*17/411, bottom: MediaQuery.of(context).size.width*17/411)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular( MediaQuery.of(context).size.width*27/411), side: BorderSide(color: Colors.white)))),
    onPressed: () {
      Get.to(() => sign_in_screen());
    }, //TODO:Sign in e basıldığında...........
  );
}

Widget button_empty_forgot_password({@required String title, @required context}) {
  return TextButton(
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize:  MediaQuery.of(context).size.width*12/411, fontFamily: "bahnschrift"),
      ),
      style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(left: MediaQuery.of(context).size.width*20/411, right: MediaQuery.of(context).size.width*20/411, top: MediaQuery.of(context).size.width*17/411, bottom: MediaQuery.of(context).size.width*17/411)),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular( MediaQuery.of(context).size.width*27/411), side: BorderSide(color: Colors.white)))),
      onPressed: () async {
        Alert(
          context: context,
          type: AlertType.warning,
          style: AlertStyle(backgroundColor: colors().brown, titleStyle: TextStyle(color: colors().grey, fontSize:  MediaQuery.of(context).size.width*20/411, fontFamily: "bahnschrift")),
          title: "Enter your Email adress to text field",
          content: await text_input_email(title: "email",context: context),
          buttons: [
            DialogButton(
              child: Text(
                "Send The Email",
                style: TextStyle(color: colors().brown, fontSize:  MediaQuery.of(context).size.width*20/411, fontFamily: "bahnschrift"),
              ),
              onPressed: () async {
                try {
                  await auth.sendPasswordResetEmail(email: email).then((value) {
                    Alert(
                      context: context,
                      type: AlertType.success,
                      style: AlertStyle(
                          backgroundColor: colors().brown, titleStyle: TextStyle(color: colors().grey, fontSize:  MediaQuery.of(context).size.width*20/411, fontFamily: "bahnschrift")),
                      title: "Reset Email sent to $email",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "OK",
                            style: TextStyle(color: colors().brown, fontSize: MediaQuery.of(context).size.width*20/411, fontFamily: "bahnschrift"),
                          ),
                          onPressed: () {
                            email = "";
                            Navigator.pop(context);
                          },
                          color: colors().yellow,
                          radius: BorderRadius.circular( MediaQuery.of(context).size.width*20/411),
                        ),
                      ],
                    ).show();
                  });
                } on FirebaseAuthException catch (e) {
                  print(e);
                  if (e.code == "invalid-email") {
                    print("çalıştı");
                    Alert(
                      context: context,
                      type: AlertType.error,
                      style: AlertStyle(
                          backgroundColor: colors().brown, titleStyle: TextStyle(color: colors().grey, fontSize:  MediaQuery.of(context).size.width*20/411, fontFamily: "bahnschrift")),
                      title: "The email address is badly formatted",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "OK",
                            style: TextStyle(color: colors().brown, fontSize:  MediaQuery.of(context).size.width*20/411, fontFamily: "bahnschrift"),
                          ),
                          onPressed: () => Navigator.pop(context),
                          color: colors().yellow,
                          radius: BorderRadius.circular( MediaQuery.of(context).size.width*20/411),
                        ),
                      ],
                    ).show();
                  }
                }
              },
              color: colors().yellow,
              radius: BorderRadius.circular( MediaQuery.of(context).size.width*20/411),
            ),
          ],
        ).show();
      } //TODO:Forgot passworda basıldığında!!!!!!!1
      );
}

Widget button_empty_give_me_words({@required String title,@required List source_list,@required List target_list,@required context}) {
    int index = 0;
    void display_my_words()async{
      print(source_list.length);
      print(target_list);
      await source_list;
      await target_list;
      int length = source_list.length;
      if(length == 0){
        Get.snackbar("ERROR", "My words is empty!");
      }else if(length >=1){
          Get.snackbar("${target_list[index]}", "${source_list[index]}");
        if(index != length-1){
          index++;
        }else if(index == length-1){
          index = 0;
        }
      }else
      Get.snackbar("ERROR", "My words is empty!");

    }


  return TextButton(
    child: Text(
      title,
      style: TextStyle(color: colors().yellow, fontSize: MediaQuery.of(context).size.width*15/411, fontFamily: "bahnschrift"),
    ),
    style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(left: MediaQuery.of(context).size.width*10/411, right: MediaQuery.of(context).size.width*10/411, top: MediaQuery.of(context).size.width*5/411, bottom: MediaQuery.of(context).size.width*5/411)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*27/411),
          side: BorderSide(color: colors().brown),
        ))),
    onPressed:(){ display_my_words();}, //TODO:Forgot passworda basıldığında!!!!!!!1
  );
}

Widget button_full_creat_account({@required String title,@required context}) {
  return ElevatedButton(
    child: button_text_brown(title: title, value:MediaQuery.of(context).size.width*20/411),
    style: ButtonStyle(
      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(left: MediaQuery.of(context).size.width*87/411, right: MediaQuery.of(context).size.width*87/411, top: MediaQuery.of(context).size.width*18/411, bottom: MediaQuery.of(context).size.width*18/411)),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      backgroundColor: MaterialStateProperty.all<Color>(colors().yellow),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular( MediaQuery.of(context).size.width*27/411),
      )),
    ),
    onPressed: () {
      Get.to(() => create_account_screen());
    }, //TODO:Create Account a basıldığında!!!!!!!!!!!!!
  );
}

Widget button_full_add_words({@required String title,@required context}) {
  return ElevatedButton(
    child: button_text_brown(title: title, value: MediaQuery.of(context).size.width*20/411),
    style: ButtonStyle(
      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(left: MediaQuery.of(context).size.width*87/411, right: MediaQuery.of(context).size.width*87/411, top: MediaQuery.of(context).size.width*18/411, bottom: MediaQuery.of(context).size.width*18/411)),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      backgroundColor: MaterialStateProperty.all<Color>(colors().yellow),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*27/411),
      )),
    ),
    onPressed: () async{
      controler_add_textfield.clear();
      if(words_all.toString()==""){
        print("boş kanka");
      }else{
       write_words('"${words_all.toString()}",').whenComplete((){
        Fluttertoast.showToast(
          msg: "words added",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: colors().brown,
          textColor: colors().yellow,
          fontSize: MediaQuery.of(context).size.width*16/411,
        );        
      });        
      }
      print(words_all.toString());
    }, //TODO:Create Account a basıldığında!!!!!!!!!!!!!
  );
}



//1)all_words_list i all_words_txt de olan elemanlar ile güncelle
//2)daha sonra all_words_list e add ile kelimeleri ekle
//3)all word list i txt dosyana yazdır

Widget button_full_sign_in({@required String title, @required double value, @required context}) {
  return ElevatedButton(
      child: button_text_brown(title: title, value: value),
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(left: MediaQuery.of(context).size.width*130/411, right: MediaQuery.of(context).size.width*130/411, top: MediaQuery.of(context).size.width*22/411, bottom: MediaQuery.of(context).size.width*22/411)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(colors().yellow),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*130/411),
        )),
      ),
      onPressed: () async {
        show_toast(message: "logging in...", context: context);
        try {
          await auth.signInWithEmailAndPassword(email: email, password: password).then((value) async {
            SharedPreferences preferences = await SharedPreferences.getInstance();
            preferences.setString("email", email);
            print("girdi");
            show_toast(message: "successful loggin", context: context);
            cs.CurrentUserEmail = auth.currentUser.email.obs;
            // FirebaseFirestore.instance.collection("users").doc(cs.CurrentUserEmail.toString()).update({
            //   "registry_date" : DateTime.now().toString(),
            //   "premium":false,
            // });
            // FirebaseFirestore.instance.collection("users").doc("user").set({
            //   cs.CurrentUserEmail.toString(): {
            //     "registry_date": DateTime.now().toString(),
            //     "premium": true
            //   }
            // });
            email = "";
            Get.to(() => days_screen());
          });
        } on FirebaseAuthException catch (e) {
          print(e);
          if (e.code == 'user-not-found') {
            Alert(
              context: context,
              type: AlertType.error,
              style: AlertStyle(
                  backgroundColor: colors().brown, titleStyle: TextStyle(color: colors().grey, fontSize: value, fontFamily: "bahnschrift")),
              title: "No user found for that email",
              buttons: [
                DialogButton(
                  child: Text(
                    "OK",
                    style: TextStyle(color: colors().brown, fontSize: value, fontFamily: "bahnschrift"),
                  ),
                  onPressed: () => Navigator.pop(context),
                  color: colors().yellow,
                  radius: BorderRadius.circular( MediaQuery.of(context).size.width*20/411),
                ),
              ],
            ).show();
          } else if (e.code == 'wrong-password') {
            Alert(
              context: context,
              type: AlertType.error,
              style: AlertStyle(
                  backgroundColor: colors().brown, titleStyle: TextStyle(color: colors().grey, fontSize: value, fontFamily: "bahnschrift")),
              title: "Wrong password provided for that user",
              buttons: [
                DialogButton(
                  child: Text(
                    "OK",
                    style: TextStyle(color: colors().brown, fontSize: value, fontFamily: "bahnschrift"),
                  ),
                  onPressed: () => Navigator.pop(context),
                  color: colors().yellow,
                  radius: BorderRadius.circular( MediaQuery.of(context).size.width*20/411),
                ),
              ],
            ).show();
          } else if (e.code == "invalid-email") {
            Alert(
              context: context,
              type: AlertType.error,
              style: AlertStyle(
                  backgroundColor: colors().brown, titleStyle: TextStyle(color: colors().grey, fontSize: value, fontFamily: "bahnschrift")),
              title: "The email address is badly formatted",
              buttons: [
                DialogButton(
                  child: Text(
                    "OK",
                    style: TextStyle(color: colors().brown, fontSize: value, fontFamily: "bahnschrift"),
                  ),
                  onPressed: () => Navigator.pop(context),
                  color: colors().yellow,
                  radius: BorderRadius.circular( MediaQuery.of(context).size.width*20/411),
                ),
              ],
            ).show();
          }
        }
      }
      // Get.to(() => days_screen());
      // if(cs.first_signin != true){
      //   print(cs.start_date);
      //   print(cs.first_signin);
      // }else{
      //   cs.start_date = DateTime.now().obs;
      //   print(cs.start_date);
      //   print(cs.first_signin);
      //   cs.first_signin = false.obs;
      //   print(cs.start_date);
      // }

      //TODO:Create Account a basıldığında!!!!!!!!!!!!!
      );
}

Widget button_full_create_account({@required String title, @required double value, @required context}) {
  return ElevatedButton(
      child: button_text_brown(title: title, value: value),
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(left:  MediaQuery.of(context).size.width*92/411, right:  MediaQuery.of(context).size.width*92/411, top:  MediaQuery.of(context).size.width*22/411, bottom:  MediaQuery.of(context).size.width*22/411)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(colors().yellow),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular( MediaQuery.of(context).size.width*130/411),
        )),
      ),
      onPressed: () async {
        show_toast(message: "creating an account...", context: context);
        try {
          await auth.createUserWithEmailAndPassword(email: email, password: password).then((value) {
            show_toast(message: "successfully created", context: context);
            FirebaseFirestore.instance.runTransaction((transaction) async {
              transaction.set(FirebaseFirestore.instance.collection("users").doc(email), {
                "mail": email,
                "first_enter": true,
                "is_recorded_today": false,
                "registry_date": [DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, DateTime.now().minute],
                "premium": false,
                "native_language":"",
                "target_language":"en",
                "video_quality":"default",
              });
            });
            Get.to(() => sign_in_screen());
          });
        } on FirebaseAuthException catch (e) {
          print(e);
          if (e.code == 'weak-password') {
            Alert(
              context: context,
              type: AlertType.error,
              style: AlertStyle(
                  backgroundColor: colors().brown, titleStyle: TextStyle(color: colors().grey, fontSize: value, fontFamily: "bahnschrift")),
              title: "Password should be at least 6 characters",
              buttons: [
                DialogButton(
                  child: Text(
                    "OK",
                    style: TextStyle(color: colors().brown, fontSize: value, fontFamily: "bahnschrift"),
                  ),
                  onPressed: () => Navigator.pop(context),
                  color: colors().yellow,
                  radius: BorderRadius.circular( MediaQuery.of(context).size.width*20/411),
                ),
              ],
            ).show();
          } else if (e.code == 'email-already-in-use') {
            Alert(
              context: context,
              type: AlertType.error,
              style: AlertStyle(
                  backgroundColor: colors().brown, titleStyle: TextStyle(color: colors().grey, fontSize: value, fontFamily: "bahnschrift")),
              title: "The email address is already in use by another account",
              buttons: [
                DialogButton(
                  child: Text(
                    "OK",
                    style: TextStyle(color: colors().brown, fontSize: value, fontFamily: "bahnschrift"),
                  ),
                  onPressed: () => Navigator.pop(context),
                  color: colors().yellow,
                  radius: BorderRadius.circular( MediaQuery.of(context).size.width*20/411),
                ),
              ],
            ).show();
          } else if (e.code == "invalid-email") {
            Alert(
              context: context,
              type: AlertType.error,
              style: AlertStyle(
                  backgroundColor: colors().brown, titleStyle: TextStyle(color: colors().grey, fontSize: value, fontFamily: "bahnschrift")),
              title: "The email address is badly formatted",
              buttons: [
                DialogButton(
                  child: Text(
                    "OK",
                    style: TextStyle(color: colors().brown, fontSize: value, fontFamily: "bahnschrift"),
                  ),
                  onPressed: () => Navigator.pop(context),
                  color: colors().yellow,
                  radius: BorderRadius.circular( MediaQuery.of(context).size.width*20/411),
                ),
              ],
            ).show();
          }
        } catch (e) {
          print(e);
        }
      });
}

Widget button_full_google({@required String title,@required context}) {
  return ElevatedButton(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          FaIcon(
            FontAwesomeIcons.google,
            size: MediaQuery.of(context).size.width*35/411,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width*21/411,
          ),
          button_text_white(title: title,context: context)
        ],
      ),
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(left: MediaQuery.of(context).size.width*45/411, right: MediaQuery.of(context).size.width*30/411, top: MediaQuery.of(context).size.width*18/411, bottom: MediaQuery.of(context).size.width*18/411)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(colors().orange_google),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular( MediaQuery.of(context).size.width*40/411),
        )),
      ),
      onPressed: () {
        googleSignIn.signIn().then((value) async {
          cs.CurrentUserEmail = await googleSignIn.currentUser.email.obs;
          FirebaseFirestore.instance.collection('users').doc(googleSignIn.currentUser.email).get().then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
            } else {
              FirebaseFirestore.instance.runTransaction((transaction) async {
                transaction.set(FirebaseFirestore.instance.collection("users").doc(cs.CurrentUserEmail.toString()), {
                  "mail": cs.CurrentUserEmail.toString(),
                  "first_enter": true,
                  "is_recorded_today": false,
                  "registry_date": [DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, DateTime.now().minute],
                  "premium": false,
                  "native_language":"",
                  "target_language":"en",
                  "video_quality":"default",
                });
              });
            }
          });

          Get.to(() => days_screen());
        });
      } //TODO:Continue with Google a basıldığında!!!!!!!!!!!!!
      );
}

Widget button_full_mail({@required String title,@required context}) {

  return ElevatedButton(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          FaIcon(
            FontAwesomeIcons.mailBulk,
            size:  MediaQuery.of(context).size.width*35/411,
          ),
          SizedBox(
            width:  MediaQuery.of(context).size.width*21/411,
          ),
          button_text_black(title: title,context: context)
        ],
      ),
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(left: MediaQuery.of(context).size.width*48/411, right: MediaQuery.of(context).size.width*50/411, top: MediaQuery.of(context).size.width*18/411, bottom: MediaQuery.of(context).size.width*18/411)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular( MediaQuery.of(context).size.width*40/411),
        )),
      ),
      onPressed: () {
        Get.to(() => sign_up_with_email());
      } //TODO:Continue with Google a basıldığında!!!!!!!!!!!!!
      );
}

Widget button_full_watch({@required String title, @required index, @required context}) {

  return ElevatedButton(
      child:button_text_brown(title: title, value: MediaQuery.of(context).size.width*20/411),
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(left: MediaQuery.of(context).size.width*50/411, right: MediaQuery.of(context).size.width*50/411, top: MediaQuery.of(context).size.width*10/411, bottom: MediaQuery.of(context).size.width*10/411)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(colors().yellow),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*130/411), side: BorderSide(color: Colors.black45))),
      ),
      onPressed: () async {
        var info = await FlutterVideoInfo().getVideoInfo("/storage/emulated/0/Android/data/burakatalay.ten_minute/files/${cs.CurrentUserEmail.toString()}_${index + 1}.mp4");
        info.filesize == 0
            ? Alert(
                context: context,
                type: AlertType.warning,
                style:
                    AlertStyle(backgroundColor: colors().brown, titleStyle: TextStyle(color: colors().grey, fontSize: MediaQuery.of(context).size.width*20/411, fontFamily: "bahnschrift")),
                title: "Video not found",
                buttons: [
                  DialogButton(
                    child: Text(
                      "OK",
                      style: TextStyle(color: colors().brown, fontSize: MediaQuery.of(context).size.width*20/411, fontFamily: "bahnschrift"),
                    ),
                    onPressed: () => Navigator.pop(context),
                    color: colors().yellow,
                    radius: BorderRadius.circular(MediaQuery.of(context).size.width*20/411),
                  ),
                ],
              ).show()
            : Get.to(() => watch_video(index: index));
      } //TODO:watch a basıldığında!!!!!!!!!!!!!

      );
}

Widget button_full_record({@required String title, @required context}) {
  return ElevatedButton(
      child: cs.is_recorded_today.toString() == "false" ? button_text_brown(title: title, value: MediaQuery.of(context).size.width*25/411) : button_text_yellow(title: title, value: MediaQuery.of(context).size.width*25/411),
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(left: MediaQuery.of(context).size.width*120/411, right: MediaQuery.of(context).size.width*120/411, top: MediaQuery.of(context).size.width*28/411, bottom: MediaQuery.of(context).size.width*28/411)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(cs.is_recorded_today.toString() == "false" ? colors().yellow : colors().brown),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*130/411), side: BorderSide(color: Colors.black45))),
      ),
      onPressed: () {
        cs.premium_account.toString()=="true"?print("premium"):myInterstitial.show();
        
        if (cs.is_recorded_today.toString() == "true") {
          Alert(
            context: context,
            type: AlertType.info,
            style: AlertStyle(backgroundColor: colors().brown, titleStyle: TextStyle(color: colors().grey, fontSize: MediaQuery.of(context).size.width*20/411, fontFamily: "bahnschrift")),
            title: "You already recorded today!\n${cs.when_record.toString()} later will be open",
            buttons: [
              DialogButton(
                child: Text(
                  "OK",
                  style: TextStyle(color: colors().brown, fontSize: MediaQuery.of(context).size.width*20/411, fontFamily: "bahnschrift"),
                ),
                onPressed: () => Get.to(()=>days_screen()),
                color: colors().yellow,
                radius: BorderRadius.circular(MediaQuery.of(context).size.width*20/411),
              ),
            ],
          ).show();
        } else{
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
            Get.to(() => take_video_screen());
          }
        }
      } //TODO:record a basıldığında!!!!!!!!!!!!!
      );
}

Widget button_full_will_record({@required String title}) {
  return ElevatedButton(
      child: button_text_yellow(title: title, value: 20.0),
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(left: 63.0, right: 63.0, top: 10.0, bottom: 10.0)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(colors().brown),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(130.0), side: BorderSide(color: Colors.grey))),
      ),
      onPressed: () => null //TODO:record gelecekte olacak basıldığında!!!!!!!!!!!!!
      );
}

Widget button_text_signin({@required context}) {
  return TextButton(
      onPressed: () {
        Get.to(() => sign_in_screen());
      },
      child: little_text_yellow(title: "Sign in", value: MediaQuery.of(context).size.width*15/411));
}
