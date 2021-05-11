import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:ten_minute/consts.dart';
import 'package:ten_minute/controller.dart';
import 'package:ten_minute/screens/days_screen.dart';
import 'package:ten_minute/screens/preview_screen.dart';
import 'package:translator/translator.dart';
import 'button_widgets.dart';
import 'text_input_widgets.dart';
import 'text_widgets.dart';


List my_word_list = [];
List translated_words_list = [];
bool alert_show=false;



List<CameraDescription> cameras;

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
//---------------------------------FOR Timer---------------------------------------//
  int _Msecond = 00;
  int _Mminute = 10;
  String _Mmzero = "";
  String _Mszero = "0";
  Timer _timer;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_Mminute == 0 && _Msecond == 0) {
        setState(() {
          timer.cancel();
          video_stop();
        });
      } else {
        setState(() {
          if (_Msecond == 0) {
            _Mminute--;
            _Msecond = 59;
          } else
            _Msecond--;
        });
      }
      if (_Mminute != 10) {
        _Mmzero = "0";
      } else
        _Mmzero = "";
      if (_Msecond < 10) {
        _Mszero = "0";
      } else
        _Mszero = "";
    });
  }
//---------------------------------FOR Timer---------------------------------------//

  final fileName = DateTime.now().millisecondsSinceEpoch.toString();
  var _recorder = true;

  final Controller_get cs = Get.put(Controller_get());

  CameraController controller;

  void show_alert(){
    show_toast(message: "My words is empty", context: context);
  }

  Future<int> read_word() async {
    try {
      final file = await File(cs.my_words_path.toString());
      String file_2 = await file.readAsString();
      if (file.isBlank || file_2.length == 0) {
        print("kelime yok");
      } else {
        String contents = await file.readAsString();
        contents = contents.substring(0,contents.length-1);
        my_word_list = await contents.split(", ");

        var _list_str = my_word_list[0].toString();
        if(_list_str.length == 0){
          show_alert();
        }else {
          var _repair_list = _list_str;

          var _repair_list_2 = "[${_repair_list}]";

          var _repair_list_3 = json.decode(_repair_list_2);
          my_word_list = _repair_list_3;
          print(my_word_list);
          setState(() {
            my_word_list = _repair_list_3;
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





  void make_translate_list()  async{
    ///read den sonra çağır
    try{
      GoogleTranslator translator = GoogleTranslator();
    for (var i in my_word_list) {
      await translator.translate(i.toString(), from:cs.native_language.toString(),to:cs.target_language.toString()).then((value) {
        translated_words_list.add(value);
      });
      i="";
    }
    setState(() {
      translated_words_list;
      print(translated_words_list);
    });
    }catch(e){
      print(e);
    }

  }



  @override
  void initState() {
    super.initState();

    controller = CameraController(
      cameras[1],
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    print("${controller.value.isRecordingVideo} kayıt durumu");

    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    setState(() {
      read_word().whenComplete(() => make_translate_list());
    });

  }

  void video_record() async {
    await controller.initialize();
    await controller.startVideoRecording();
    setState(() {
      startTimer();
      _recorder = true;
      print("kayıtta");
      _recorder = false;
    });
  }

  void video_stop() async {
    await controller.stopVideoRecording().then((file) {
      if (mounted) setState(() {});
      if (file != null) {
        print('Video recorded to ${file.path}');

        cs.first_video_path = file.path.obs;
        print(cs.first_video_path);
      } else
        print("başaramadım...");
    });

    print(controller.value.isRecordingVideo);
    setState(() {
      controller.initialize();
      _recorder = false;
      print("kayıt bitti");
      _recorder = true;
      _timer.cancel();
      _Msecond = 00;
      _Mminute = 10;

       my_word_list = [];
       translated_words_list = [];

      Get.to(() => preview()).whenComplete(() => Navigator.of(context).pop());
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (!controller.value.isInitialized) {
      return Container();
    }
    return CameraPreview(
      controller,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SafeArea(
            child: Row(
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
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                child: _recorder
                    ? Icon(
                  Icons.fiber_manual_record,
                  color: colors().yellow,
                  size: MediaQuery.of(context).size.width*30/411,
                )
                    : Icon(
                  Icons.stop,
                  color: Colors.red,
                  size: MediaQuery.of(context).size.width*30/411,
                ),
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(left: MediaQuery.of(context).size.width*20/411, right: MediaQuery.of(context).size.width*20/411, top: MediaQuery.of(context).size.width*17/411, bottom: MediaQuery.of(context).size.width*17/411)),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*27/411), side: BorderSide(color: colors().brown)))),
                onPressed: () {
                  setState(() {
                    _recorder ? video_record() : video_stop();
                  });
                },
              ),
              Text(
                "$_Mmzero$_Mminute:$_Mszero$_Msecond",
                style: TextStyle(fontSize: MediaQuery.of(context).size.width*50/411, color: colors().grey_2, fontWeight: FontWeight.bold),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: _Mminute < 9 ? colors().yellow : colors().grey_2,
                      child: Center(
                        child: Text(
                          "N",
                          style: TextStyle(color: colors().grey_2),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: _Mminute < 8 ? colors().yellow : colors().grey_2,
                      child: Center(
                        child: Text(
                          "I",
                          style: TextStyle(color: colors().grey_2),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: _Mminute < 7 ? colors().yellow : colors().grey_2,
                      child: Center(
                        child: Text(
                          "C",
                          style: TextStyle(color: colors().grey_2),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: _Mminute < 6 ? colors().yellow : colors().grey_2,
                      child: Center(
                        child: Text(
                          "E",
                          style: TextStyle(color: colors().grey_2),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: _Mminute < 5 ? colors().yellow : colors().grey_2,
                      child: Center(
                        child: Text(
                          "-",
                          style: TextStyle(color: colors().grey_2),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: _Mminute < 4 ? colors().yellow : colors().grey_2,
                      child: Center(
                        child: Text(
                          "W",
                          style: TextStyle(color: colors().grey_2),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: _Mminute < 3 ? colors().yellow : colors().grey_2,
                      child: Center(
                        child: Text(
                          "O",
                          style: TextStyle(color: colors().grey_2),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: _Mminute < 2 ? colors().yellow : colors().grey_2,
                      child: Center(
                        child: Text(
                          "R",
                          style: TextStyle(color: colors().grey_2),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: _Mminute < 1 ? colors().yellow : colors().grey_2,
                      child: Center(
                        child: Text(
                          "K",
                          style: TextStyle(color: colors().grey_2),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: _Mminute == 0 && _Msecond == 0 ? colors().yellow : colors().grey_2,
                      child: Center(
                        child: Text(
                          "!",
                          style: TextStyle(color: colors().grey_2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class take_video_screen extends StatefulWidget {
  @override
  _take_video_screenState createState() => _take_video_screenState();
}

class _take_video_screenState extends State<take_video_screen> {

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: [
        GestureType.onTap,
        GestureType.onPanUpdateDownDirection,
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: colors().brown,
            body: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  CameraApp(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    middle_header_text_grey(title: "ADD NEW WORDS",context: context),
                    text_input_words(title: "WORD",context: context),
                    button_full_add_words(title: "ADD",context: context),
                    Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)),
                  ],),
                ],
              ),
            ),
          ), 
      ),
    );
  }
}

