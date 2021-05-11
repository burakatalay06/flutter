import 'package:connection_status_bar/connection_status_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import '../widgets/button_widgets.dart';
import '../widgets/text_input_widgets.dart';
import '../widgets/text_widgets.dart';

class sign_up_with_email extends StatefulWidget {
  @override
  _sign_up_with_emailState createState() => _sign_up_with_emailState();
}

class _sign_up_with_emailState extends State<sign_up_with_email> {
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
                        little_header_text_grey(title: "SIGN UP WITH EMAIL", context: context),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    text_input_create_email(title: "Email", context: context),
                    text_input_create_password(title: "Password", context: context),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    button_full_create_account(title: "Create Account", value: MediaQuery.of(context).size.width * 20 / 411, context: context),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 50 / 411,
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


/*
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: MediaQuery.of(context).size.width*50/411,
                    color: colors().yellow,
                  ),
                  onPressed: () {
                     my_word_list = [];
                     translated_words_list = [];
                    Get.to(() => days_screen(),
                    );
                  }),
              AutoSizeText(
                "#${cs.day_calculator.toString()}",
                style: TextStyle(color: colors().brown, fontSize: MediaQuery.of(context).size.width*50/411, fontFamily: "bahnschrift"),
                textAlign: TextAlign.center,
                maxLines: 1,
                minFontSize: 20,
              ),
              button_empty_give_me_words(title: "display my words",source_list: my_word_list,target_list: translated_words_list,context: context),
            ],
          ),
*/