import 'package:get/get.dart';
import 'package:music_playlist_app/app/data/model/DeezerTrack.dart';

class SecondController extends GetxController {
  RxList<DeezerTrack> playList = <DeezerTrack>[].obs;

  @override
  void onInit() {
    playList.value = Get.arguments;
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  String formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
