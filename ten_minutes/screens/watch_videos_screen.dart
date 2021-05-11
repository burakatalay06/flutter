import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ten_minute/widgets/text_widgets.dart';
import 'package:video_player/video_player.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share/share.dart';

import '../consts.dart';
import '../controller.dart';
import 'my_videos.dart';

//TODO: preview screen e splash screen ekle en başta null döndürüyor video player!!!!
// TODO: ABİ yinelenmiş global key hatası alıyorsan get material app i bir kere kullan aq

///TODO: UYGULAMA SİLİNİNCE VİDEOLAR SİLİNİYOR!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

class watch_video extends StatefulWidget {
  int index;
  watch_video({Key key, @required this.index}) : super(key: key);

  @override
  _watch_videoState createState() => _watch_videoState();
}

class _watch_videoState extends State<watch_video> {
  bool show_watch_videos = false;
  VoidCallback videoPlayerListener;
  VideoPlayerController videoController;

  ChewieController _chewieController;

  final Controller_get cs = Get.put(Controller_get());

  String video_path({@required name}) {
    return "/storage/emulated/0/Android/data/burakatalay.ten_minute/files/${cs.CurrentUserEmail.toString()}_${name + 1}.mp4";
  }

  // VideoPlayerController _controller;

  @override
  void dispose() {
    videoController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // _controller = VideoPlayerController.file(File(video_path(name: widget.index)));///first video path vardı
    _startVideoPlayer_preview();
  }

  void save_video() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.mediaLibrary,
    ].request();

    Directory tempDir = await getExternalStorageDirectory();
    String tempPath = tempDir.path + "/${cs.day_calculator.toString()}.mp4";

    ///TODO:FİLE NAME BURAYA GETİR

    File savedVideo = await File(cs.first_video_path.toString()).copy(tempPath);
    File(cs.first_video_path.toString()).delete();
    cs.saved_video_path = savedVideo.path.obs;
    show_stroge_toast(message: "video saved");
    print(cs.saved_video_path);
    videoController.pause();
  }

  void delete_video() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.mediaLibrary,
    ].request();
    File(video_path(name: widget.index)).delete();
    _chewieController.pause();
    show_stroge_toast(message: "video deleted");
  }

  void show_stroge_toast({@required String message}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: colors().brown,
      textColor: colors().yellow,
      fontSize: MediaQuery.of(context).size.width * 16 / 411,
    );
  }

  Future<void> _startVideoPlayer_preview() async {
    if (File(video_path(name: widget.index)) == null) {
      return;
    }
    final VideoPlayerController vController = await VideoPlayerController.file(File(video_path(name: widget.index).toString()));
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

  _saveVideoGallery() async {
    setState(() {
      show_watch_videos = true;
    });
    var _path = await video_path(name: widget.index).toString();
    final result = await ImageGallerySaver.saveFile(_path).whenComplete(() {
      show_stroge_toast(message: "Video saved to gallery");
      setState(() {
        show_watch_videos = false;
      });
    });
  }

  share_to_video() async {
    String _path = await video_path(name: widget.index);
    
    Share.shareFiles([_path],
        text:
            "I am learning to new language(${cs.target_language.toString()}).The ten minutes app has helped me a lot and I have been using it for ${cs.day_calculator.toString()} days.For download https://play.google.com/store/apps/details?id=burakatalay.ten_minute");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: colors().brown,
          title: little_text_grey(title: "10 MINUTES", value: MediaQuery.of(context).size.width*20/411),
          leading: BackButton(
            onPressed: () => Get.to(() => my_videos()),
          ),
        ),
        backgroundColor: colors().grey_2,
        body: ModalProgressHUD(
          inAsyncCall: show_watch_videos,
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
                height: MediaQuery.of(context).size.width * 15 / 411,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    child: Column(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.save,
                          color: Colors.green,
                          size: MediaQuery.of(context).size.width * 30 / 411,
                        ),
                        little_text_yellow(title: "Save to gallery", value: MediaQuery.of(context).size.width*10/411),
                      ],
                    ),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 30 / 411,
                            right: MediaQuery.of(context).size.width * 30 / 411,
                            top: MediaQuery.of(context).size.width * 15 / 411,
                            bottom: MediaQuery.of(context).size.width * 15 / 411)),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 27 / 411),
                            side: BorderSide(color: colors().grey)))),
                    onPressed: () {
                      setState(() {
                        _saveVideoGallery();
                      });
                    },
                  ),
                  TextButton(
                    child: Column(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.shareAlt,
                          color: Colors.green,
                          size: MediaQuery.of(context).size.width * 30 / 411,
                        ),
                        little_text_yellow(title: "Share to video", value: MediaQuery.of(context).size.width*10/411),
                      ],
                    ),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 30 / 411,
                            right: MediaQuery.of(context).size.width * 30 / 411,
                            top: MediaQuery.of(context).size.width * 15 / 411,
                            bottom: MediaQuery.of(context).size.width * 15 / 411)),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 27 / 411),
                            side: BorderSide(color: colors().grey)))),
                    onPressed: () {
                      share_to_video(); //bunu çöz tek sıkıntı bu
                    },
                  ),
                  TextButton(
                    child: Column(
                      children: [
                        Icon(
                          Icons.delete,
                          size: MediaQuery.of(context).size.width * 30 / 411,
                          color: Colors.red,
                        ),
                        little_text_yellow(title: "Delete to video", value: MediaQuery.of(context).size.width*10/411),
                      ],
                    ),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 30 / 411,
                            right: MediaQuery.of(context).size.width * 30 / 411,
                            top: MediaQuery.of(context).size.width * 15 / 411,
                            bottom: MediaQuery.of(context).size.width * 15 / 411)),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 27 / 411),
                            side: BorderSide(color: colors().grey)))),
                    onPressed: () {
                      setState(() {
                        delete_video();
                        Get.back();
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
