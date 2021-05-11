import 'package:flutter/material.dart';
import 'package:ten_minute/consts.dart';
import 'package:ten_minute/widgets/button_widgets.dart';
import 'package:ten_minute/widgets/text_widgets.dart';
import 'package:connection_status_bar/connection_status_bar.dart';

class create_account_screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/account.png"),
            fit: BoxFit.cover,
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: ConnectionStatusBar(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    little_header_text_grey(title: "CREAT AN ACCOUNT",context: context),
                  ],
                ),
              ],),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      little_text_grey(title: "Knowledge is of no value unless\nyou put it into practice.", value: MediaQuery.of(context).size.width*22/411),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      little_text_white(title: "-Anton Chekhov", value: MediaQuery.of(context).size.width*24/411),
                      SizedBox(
                        width: MediaQuery.of(context).size.width*25/411,
                      ),
                    ],
                  ),
                ],),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Row(mainAxisAlignment:MainAxisAlignment.center,children:[button_full_google(title: "Continue with Google",context: context)]),
                SizedBox(height: MediaQuery.of(context).size.width*25/411,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    button_full_mail(title: "Sign up with Email",context: context),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    little_text_white(title: "Already have an account?", value:MediaQuery.of(context).size.width*15/411),
                    button_text_signin(context: context),
                  ],
                )
              ],),
            ],
          ),
        ),
      ),
    );
  }
}
