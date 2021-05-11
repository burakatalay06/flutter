
import 'dart:ui';

import 'package:connection_status_bar/connection_status_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller.dart';
import '../widgets//text_widgets.dart';
import '../widgets/button_widgets.dart';
import 'package:responsive_framework/responsive_framework.dart';


class welcome_screen extends StatelessWidget {
  final Controller_get cs = Get.put(Controller_get());

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/welcome.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: ConnectionStatusBar(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: AssetImage("assets/images/logo.png"),
                  ),
                ],
              ),

              ///logo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  big_text_white(title: "WELCOME TO",context: context),
                  big_text_yellow(title: " 10MIN",context: context),
                ],
              ),

              ///header text

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      little_text_grey(title: "I want you to spend ", value: MediaQuery.of(context).size.width*24/411),//24
                      little_text_yellow(title: "10 minutes", value: MediaQuery.of(context).size.width*24/411),
                    ],
                  ),
                  little_text_grey(title: "everyday\nYou can learn language by yourself!", value: MediaQuery.of(context).size.width*24/411),
                ],
              ),
              ///middle text
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                button_full_creat_account(title: "Create Account",context: context),
                SizedBox(height: MediaQuery.of(context).size.width*26/411,width: 1,),
                button_empty_sign_in(title: "Sign in",context: context),

              ],),
            ],
          ),
        ),
      ),
    );
  }
}
