import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:music_playlist_app/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    final c = controller;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'My Playlist',
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Obx(
        () => Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ...c.playList.keys.map((key) {
                    final playlist = c.playList[key];
                    return InkWell(
                      onTap: () {
                        Get.toNamed(Routes.SECOND, arguments: playlist);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.network(
                              playlist!.first.albumCover,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    key,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    playlist.first.title,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                if (c.playingPlayList?.key == key) {
                                  if (c.player.playing) {
                                    c.player.pause();
                                  } else {
                                    c.player.play();
                                  }
                                } else {
                                  c.playTrack(playlist.first);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: Icon(
                                  size: 30,
                                  (c.player.playing &&
                                          c.playingPlayList!.key == key
                                      ? Icons.pause
                                      : Icons.play_arrow),
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            if (c.playingPlayList != null) ...[
              StreamBuilder(
                stream: c.player.positionStream,
                builder: (context, snapshot) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final position = snapshot.data ?? Duration.zero;
                      final currentIndex = c.playingPlayList!.value.indexOf(
                        c.current.value!,
                      );
                      final secondsBefore = currentIndex * 30;
                      final totalSeconds = c.playingPlayList!.value.length * 30;
                      final playedSeconds =
                          secondsBefore + position.inSeconds.clamp(0, 30);
                      final progressRatio = playedSeconds / totalSeconds;
                      final width = constraints.maxWidth * progressRatio;

                      return Stack(
                        children: [
                          Container(height: 5, color: Colors.grey),
                          Container(
                            height: 5,
                            width: width,
                            color: Colors.amberAccent,
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              Container(
                padding: const EdgeInsets.all(12),
                child: Row(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      c.playingPlayList!.value.first.albumCover,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            c.playingPlayList!.key,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          Text(
                            c.playingPlayList!.value.first.title,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        if (c.player.playing) {
                          c.player.pause();
                        } else {
                          c.player.play();
                        }
                      },
                      child: Icon(
                        size: 40,
                        (c.player.playing ? Icons.pause : Icons.play_arrow),
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
