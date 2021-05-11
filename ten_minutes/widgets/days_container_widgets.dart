import 'package:auto_size_text/auto_size_text.dart';
import 'package:connection_status_bar/connection_status_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../consts.dart';
import 'button_widgets.dart';
import 'text_widgets.dart';

Container watch({@required index, @required context}) {
  var registry_date = DateTime(cs.registry_year.value.toInt(), cs.registry_month.value.toInt(), cs.registry_day.value.toInt());
  registry_date = registry_date.add(Duration(days: index));

  return Container(
    color: colors().brown,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(child: little_text_grey(title: "${registry_date.day}.${registry_date.month}.${registry_date.year}", value: MediaQuery.of(context).size.width*30/411)),
        Expanded(flex:2,child: little_text_grey(title: "#${index + 1}", value: MediaQuery.of(context).size.width*70/411)),
        Expanded(child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            button_full_watch(title: "Watch", index: index, context: context),
          ],
        )),
      ],
    ),
  );
}

Container record({@required context}) {
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/images/tree.png"),
        fit: BoxFit.cover,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: ConnectionStatusBar(),
              ),
              AutoSizeText(
                "${DateTime.now().day}.${DateTime.now().month.toString().length == 1 ? "0" : ""}${DateTime.now().month}.${DateTime.now().year}",
                style: TextStyle(color: colors().grey,
                    fontSize:  MediaQuery.of(context).size.width*70/411,
                    fontFamily: "bahnschrift"),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: AutoSizeText(
            "#${cs.day_calculator.toString()}",
            style: TextStyle(
                color: cs.is_recorded_today.toString() == "false" ? colors().grey_2 : colors().yellow, fontSize: MediaQuery.of(context).size.width*300/411, fontFamily: "bahnschrift"),
            textAlign: TextAlign.center,
            maxLines: 1,
            minFontSize: 100,
          ),
        ),
        Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                button_full_record(title: "Record", context: context),
              ],
            )),
      ],
    ),
  );
}

Container will_record() {
  return Container(
    color: colors().brown,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        little_text_grey(title: "22.03.2021", value: 30.0),
        little_text_grey(title: "#3", value: 70.0),
        button_full_will_record(title: "Record"),
      ],
    ),
  );
}
