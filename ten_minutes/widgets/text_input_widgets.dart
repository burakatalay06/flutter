import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ten_minute/widgets/camera_widget.dart';

import '../consts.dart';
import 'button_widgets.dart';

Widget text_input_email({@required String title,@required context}) {
  return Container(
    width: MediaQuery.of(context).size.width*350/411,
    height: MediaQuery.of(context).size.width*100/411,
    child: TextField(
      keyboardType: TextInputType.emailAddress,
      cursorColor: Colors.black,
      obscureText: false,
      decoration: InputDecoration(
        hintText: 'Type your mail',
        focusColor: Colors.black,
        fillColor: Colors.white12,
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(13.0))),
        labelStyle: TextStyle(color: colors().brown, fontSize: 27.0, fontFamily: "bahnschrift"),
        labelText: title,
      ),
      onChanged: (String text) {
        email = text;
      }, //TODO:Email girildiğinde!!!!
    ),
  );
}

Widget text_input_create_email({@required String title,@required context}) {
  return Container(
    width: MediaQuery.of(context).size.width*350/411,
    height:  MediaQuery.of(context).size.width*100/411,
    child: TextField(
      keyboardType: TextInputType.emailAddress,
      cursorColor: Colors.black,
      obscureText: false,
      decoration: InputDecoration(
        hintText: 'Type your mail',
        focusColor: Colors.black,
        fillColor: Colors.white12,
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular( MediaQuery.of(context).size.width*13/411))),
        labelStyle: TextStyle(color: colors().brown, fontSize:  MediaQuery.of(context).size.width*27/411, fontFamily: "bahnschrift"),
        labelText: title,
      ),
      onChanged: (String text) {
        email = text;
      }, //TODO:Email girildiğinde!!!!
    ),
  );
}

Widget text_input_create_password({@required String title,@required context}) {
  return Container(
    width:  MediaQuery.of(context).size.width*350/411,
    height: MediaQuery.of(context).size.width*100/411,
    child: TextField(
      cursorColor: Colors.black,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Type your password',
        focusColor: Colors.black,
        fillColor: Colors.white12,
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular( MediaQuery.of(context).size.width*13/411))),
        labelStyle: TextStyle(color: colors().brown, fontSize:  MediaQuery.of(context).size.width*27/411, fontFamily: "bahnschrift"),
        labelText: title,
      ),
      onChanged: (String text) {
        password = text;
      }, //TODO:Email girildiğinde!!!!
    ),
  );
}

Widget text_input_password({@required String title,@required context}) {
  return Container(
    width: MediaQuery.of(context).size.width*350/411,
    height:  MediaQuery.of(context).size.width*100/411,
    child: TextField(
      cursorColor: Colors.black,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Type your password',
        focusColor: Colors.black,
        fillColor: Colors.white12,
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular( MediaQuery.of(context).size.width*13/411))),
        labelStyle: TextStyle(color: colors().brown, fontSize:  MediaQuery.of(context).size.width*27/411, fontFamily: "bahnschrift"),
        labelText: title,
      ),
      onChanged: (String text) {
        password = text;
      }, //TODO:Email girildiğinde!!!!
    ),
  );
}

final controler_add_textfield = TextEditingController();
Widget text_input_words({@required String title,@required context}) {
  
  return Container(
    width: MediaQuery.of(context).size.width*350/411,
    height: MediaQuery.of(context).size.width*100/411,
    child: TextField(
      //inputFormatters: [BlacklistingTextInputFormatter(RegExp(r"\s")),],
      keyboardType: TextInputType.name,
      cursorColor: Colors.black,
      obscureText: false,
      decoration: InputDecoration(
        focusColor: Colors.black,
        fillColor: Colors.white12,
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*13/411))),
        labelStyle: TextStyle(color: colors().brown, fontSize: MediaQuery.of(context).size.width*27/411, fontFamily: "bahnschrift"),
        labelText: title,
      ),
      onChanged: (String text) {
        String text_2 = text.trimLeft();
        String text_3 = text_2.trimRight();
        words_all = text_3;
      },//TODO:Words girildiğinde!!!!
      controller: controler_add_textfield,
      onTap: (){
        words_all ="";
        controler_add_textfield.clear();
        
      },
    ),
  );
}
