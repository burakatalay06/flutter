import 'dart:io';


import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ten_minute/widgets/text_widgets.dart';
import 'package:video_player/video_player.dart';
import 'dart:math' as math;

import '../consts.dart';
import '../controller.dart';
import '../widgets/camera_widget.dart';
import 'days_screen.dart';
import 'package:video_compress/video_compress.dart';

//TODO: preview screen e splash screen ekle en başta null döndürüyor video player!!!!
// TODO: ABİ yinelenmiş global key hatası alıyorsan get material app i bir kere kullan aq

///TODO: UYGULAMA SİLİNİNCE VİDEOLAR SİLİNİYOR!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
///


class preview extends StatefulWidget {
  @override
  _previewState createState() => _previewState();
}

class _previewState extends State<preview> {
  bool show_preview = false;
  
  VideoPlayerController videoController;
  ChewieController _chewieController;

  final Controller_get cs = Get.put(Controller_get());

  @override
  void dispose() {
    videoController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _startVideoPlayer_preview();
  }

  void save_video() async {

    setState(() {
          show_preview = true;
        });
        show_stroge_toast(message: "video compressing... \n target quality ${cs.video_quality.toString()}");
    await VideoCompress.setLogLevel(0);
    

    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.mediaLibrary,
    ].request();

    Directory tempDir = await getExternalStorageDirectory();
    String tempPath = tempDir.path + "/${cs.CurrentUserEmail.toString()}_${cs.day_calculator.toString()}.mp4";

    ///TODO:FİLE NAME BURAYA GETİR
    final ilkhali = await FlutterVideoInfo().getVideoInfo(File(cs.first_video_path.toString()).path);
    print("ilk hali ${await ilkhali.filesize}");
    
    final info = await VideoCompress.compressVideo(
      cs.first_video_path.toString(),
    quality: cs.video_quality.toString() == "medium"?VideoQuality.MediumQuality:cs.video_quality.toString()=="high"?VideoQuality.HighestQuality:cs.video_quality.toString()=="low"?VideoQuality.LowQuality:VideoQuality.DefaultQuality,
    deleteOrigin: true,
    includeAudio: true,
    );

    final sonhali = await FlutterVideoInfo().getVideoInfo(info.path);
    print("son hali${await sonhali.filesize}");
    
    cs.first_video_path = await info.path.obs;

    File savedVideo = await File(cs.first_video_path.toString()).copy(tempPath);
    File(cs.first_video_path.toString()).delete();

    

    cs.saved_video_path = savedVideo.path.obs;

    setState(() {
          show_preview = false;
        });
    show_stroge_toast(message: "video compressed and saved");
    print(cs.saved_video_path);
    _chewieController.pause().whenComplete((){
      Navigator.push(context, MaterialPageRoute(builder: (context) => days_screen())).whenComplete(() => Navigator.of(context).pop());
    });
     
  }

  Future<void> delete_video() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.mediaLibrary,
    ].request();
    await File(cs.first_video_path.toString()).delete();
    print(cs.saved_video_path);
    show_stroge_toast(message: "video deleted");
    cs.saved_video_path = "".obs;
    _chewieController.pause();
  }

  void show_stroge_toast({@required String message}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: colors().brown,
      textColor: colors().yellow,
      fontSize: MediaQuery.of(context).size.width*16/411,
    );
  }

  Future<void> _startVideoPlayer_preview() async {
    if (await File(cs.first_video_path.toString()) == null) {
      return;
    }else{
     final VideoPlayerController vController =  VideoPlayerController.file( File(cs.first_video_path.toString()));
    await Future.wait([vController.initialize()]);
    _chewieController = ChewieController(
      videoPlayerController: vController, autoPlay: false, looping: false,
      showControls: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: colors().yellow,
        handleColor: Colors.blue,
        backgroundColor: colors().grey,
        bufferedColor: colors().brown,
      ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      //autoInitialize: true,
    );
    setState(() {});
    }

  }

  ///TODO: çıkmak için 2 kere bas dedirt geri gelmeyi engelle

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
          home: Scaffold(
              appBar: AppBar(
                leading: BackButton(
                  onPressed: () {
                    delete_video().whenComplete(() => Get.to(()=>days_screen()).whenComplete(() => Navigator.of(context).pop()));
                  },
                ),
                backgroundColor: colors().brown,
                title: little_text_grey(title: "10 MINUTES", value: MediaQuery.of(context).size.width*20/411),
              ),
              backgroundColor: colors().grey_2,
              body: ModalProgressHUD(
                inAsyncCall: show_preview,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: _chewieController != null && _chewieController.videoPlayerController.value.isInitialized
                          ? Chewie(
                              controller: _chewieController,
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                CircularProgressIndicator(),
                                SizedBox(height: 20),
                                Text('Loading'),
                              ],
                            ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width*15/411,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextButton(
                          child: Column(
                            children: [
                              Icon(
                                Icons.save_alt_sharp,
                                color: Colors.green,
                                size: MediaQuery.of(context).size.width*30/411,
                              ),
                              little_text_yellow(title: "Save to my videos", value: MediaQuery.of(context).size.width*10/411),
                            ],
                          ),
                          
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(left: MediaQuery.of(context).size.width*40/411, right: MediaQuery.of(context).size.width*40/411, top: MediaQuery.of(context).size.width*15/411, bottom: MediaQuery.of(context).size.width*15/411)),
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*27/411), side: BorderSide(color: colors().grey)))),
                          onPressed: () {
                            setState(() {
                              save_video();
                             
                            });
                          },
                        ),
                        TextButton(
                          child: Column(
                            children: [
                              Icon(
                                Icons.delete,
                                size: MediaQuery.of(context).size.width*30/411,
                                color: Colors.red,
                              ),
                              little_text_yellow(title: "Delete to video", value: MediaQuery.of(context).size.width*10/411),
                            ],
                          ),
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(left: MediaQuery.of(context).size.width*50/411, right: MediaQuery.of(context).size.width*50/411, top: MediaQuery.of(context).size.width*15/411, bottom: MediaQuery.of(context).size.width*15/411)),
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*27/411), side: BorderSide(color: colors().grey)))),
                          onPressed: () {
                            setState(() {
                              delete_video().whenComplete(() => Get.to(() => take_video_screen()).whenComplete(() => Navigator.of(context).pop()));
                            });
                          }, //TODO:Forgot passworda basıldığında!!!!!!!1
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          
        );
  }
}
