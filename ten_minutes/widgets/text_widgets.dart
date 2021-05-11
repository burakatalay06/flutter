import 'package:flutter/material.dart';

import 'package:ten_minute/consts.dart';

Widget big_text_white({@required String title, @required context}) {
  return Text(
    title,
    style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 35 / 411, fontFamily: "bahnschrift"),
  );
}

Widget big_text_yellow({@required String title, @required context}) {
  return Text(
    title,
    style: TextStyle(color: colors().yellow, fontSize: MediaQuery.of(context).size.width * 35 / 411, fontFamily: "bahnschrift"),
  );
}

Widget little_text_yellow({@required String title, @required double value}) {
  return Text(
    title,
    style: TextStyle(color: colors().yellow, fontSize: value, fontFamily: "bahnschrift"),
  );
}

Widget little_text_white({@required String title, @required double value}) {
  return Text(
    title,
    style: TextStyle(color: Colors.white, fontSize: value, fontFamily: "bahnschrift"),
    textAlign: TextAlign.center,
  );
}

Widget little_text_grey({@required String title, @required double value}) {
  return Text(
    title,
    style: TextStyle(color: colors().grey, fontSize: value, fontFamily: "bahnschrift"),
    textAlign: TextAlign.center,
  );
}

Widget little_text_grey_2({@required String title, @required double value}) {
  return Text(
    title,
    style: TextStyle(color: colors().grey_2, fontSize: value, fontFamily: "bahnschrift"),
    textAlign: TextAlign.center,
  );
}

Widget button_text_brown({@required String title, @required double value}) {
  return Text(
    title,
    style: TextStyle(color: colors().brown, fontSize: value, fontFamily: "bahnschrift"),
    textAlign: TextAlign.center,
  );
}

Widget button_text_yellow({@required String title, @required double value}) {
  return Text(
    title,
    style: TextStyle(color: colors().yellow, fontSize: value, fontFamily: "bahnschrift"),
    textAlign: TextAlign.center,
  );
}

Widget button_text_white({@required String title, @required context}) {
  return Text(
    title,
    style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 20 / 411, fontFamily: "bahnschrift"),
    textAlign: TextAlign.center,
  );
}

Widget button_text_black({@required String title, @required context}) {
  return Text(
    title,
    style: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width * 20 / 411, fontFamily: "bahnschrift"),
    textAlign: TextAlign.center,
  );
}

Widget little_header_text_grey({@required String title, @required context}) {
  return Text(
    title,
    style: TextStyle(color: colors().grey, fontSize: MediaQuery.of(context).size.width * 20 / 411, fontFamily: "bahnschrift"),
    textAlign: TextAlign.center,
  );
}

Widget middle_header_text_grey({@required String title, @required context}) {
  return Text(
    title,
    style: TextStyle(color: colors().grey, fontSize: MediaQuery.of(context).size.width * 30 / 411, fontFamily: "bahnschrift"),
    textAlign: TextAlign.center,
  );
}
