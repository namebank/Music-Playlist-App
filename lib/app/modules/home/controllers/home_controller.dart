import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:music_playlist_app/app/data/model/DeezerTrack.dart';

class HomeController extends GetxController {
  final AudioPlayer player = AudioPlayer();
  Rxn<DeezerTrack> current = Rxn(null);
  List playListNames = [
    'Tect House Vibes',
    'Summer Hits',
    'Techno 2021',
    'Vibe with me',
    'Listen&chill',
  ];
  RxMap<String, List<DeezerTrack>> playList = <String, List<DeezerTrack>>{}.obs;
  MapEntry<String, List<DeezerTrack>>? get playingPlayList => playList.entries
      .where((e) => e.value.any((deezer) => deezer == current.value))
      .firstOrNull;
  @override
  void onInit() {
    fetchPlaylist();
    player.playerStateStream.listen((state) {
      final processing = state.processingState;
      if (processing == ProcessingState.completed) {
        skipNext();
      }
      current.refresh();
    });
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

  Future<void> fetchPlaylist() async {
    for (String name in playListNames) {
      final response = await http.get(
        //Uri.parse('https://api.deezer.com/search?q=omar+apollo'),
        Uri.parse(
          'https://api.deezer.com/search?q=${name.replaceAll(' ', '+')}',
        ),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> trackList = data['data'];
        final listSong = trackList
            .map((trackJson) => DeezerTrack.fromJson(trackJson))
            .toList();
        playList[name] = listSong;
      } else {
        Get.showSnackbar(
          GetSnackBar(
            title: 'Error fetch',
            message: 'statuscode:${response.statusCode}',
          ),
        );
      }
    }
  }

  void playTrack(DeezerTrack track) async {
    try {
      current.value = track;
      await player.setUrl(track.previewUrl);
      player.play();
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  void skipNext() {
    final currentIndex = playingPlayList!.value.indexOf(current.value!);
    if (currentIndex + 1 < playList.length) {
      playTrack(playingPlayList!.value[currentIndex + 1]);
    } else {
      playTrack(playingPlayList!.value.first);
    }
  }

  String formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
