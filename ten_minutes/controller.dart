import 'package:get/get.dart';



///cs.day_calculator.value.toInt(), ile kullanılıyor aq :D




class Controller_get extends GetxController{
  var first_video_path;
  var saved_video_path;
  var CurrentUserEmail;

  var all_word_path;
  var my_words_path;

  var target_language;
  var native_language;
  var video_quality;


  dynamic first_signin = Rx<bool>(true);
  dynamic is_recorded_today = Rx<bool>(false);
  dynamic premium_account = Rx<bool>(null);
  dynamic day_calculator = Rx<int>(0.toInt());

  dynamic when_record ;

  dynamic registry_year = Rx<int>(0.toInt());
  dynamic registry_month = Rx<int>(0.toInt());
  dynamic registry_day = Rx<int>(0.toInt());






}
