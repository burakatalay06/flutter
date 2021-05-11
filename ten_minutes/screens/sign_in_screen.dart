

import 'package:connection_status_bar/connection_status_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import '../controller.dart';
import '../widgets//text_widgets.dart';
import '../widgets/button_widgets.dart';
import '../widgets/text_input_widgets.dart';

class sign_in_screen extends StatefulWidget {
  @override
  _sign_in_screenState createState() => _sign_in_screenState();
}

class _sign_in_screenState extends State<sign_in_screen> {
  final Controller_get cs = Get.put(Controller_get());

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/account.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: ConnectionStatusBar(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        little_header_text_grey(title: "SIGN IN",context: context),
                      ],
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        text_input_email(
                          title: "Email",
                          context: context,
                        ),
                        text_input_password(title: "Password",context:context),
                        SizedBox(height: MediaQuery.of(context).size.width*60/411,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            button_full_sign_in(title: "Sign in", value: MediaQuery.of(context).size.width*20/411, context: context),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            little_header_text_grey(title: "OR",context: context),
                          ],
                        ),
                        Row(mainAxisAlignment:MainAxisAlignment.center,children:[button_full_google(title: "Continue With Google",context: context)], ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width*20/411,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        button_empty_forgot_password(title: "FORGOT YOUR PASSWORD?", context: context),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
