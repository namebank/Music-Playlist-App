import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:music_playlist_app/app/modules/home/controllers/home_controller.dart';

import '../controllers/second_controller.dart';

class SecondView extends GetView<SecondController> {
  const SecondView({super.key});
  @override
  Widget build(BuildContext context) {
    final c = controller;
    final homeCrl = Get.find<HomeController>();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(221, 43, 132, 179),
        body: Obx(
          () => c.playList.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    if (homeCrl.current.value != null)
                      Container(
                        color: const Color.fromARGB(221, 15, 51, 71),
                        child: ListTile(
                          leading: Image.network(
                            homeCrl.current.value!.albumCover,
                            width: 50,
                          ),
                          title: Text(
                            homeCrl.current.value!.title,
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            homeCrl.current.value!.artist,
                            style: TextStyle(color: Colors.grey),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  (homeCrl.player.playing
                                      ? Icons.pause
                                      : Icons.play_arrow),
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  if (homeCrl.player.playing) {
                                    homeCrl.player.pause();
                                  } else {
                                    homeCrl.player.play();
                                  }
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.skip_next,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  homeCrl.skipNext();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    Expanded(
                      child: DraggableScrollableSheet(
                        initialChildSize: 1,

                        builder: (context, scrollController) {
                          return CustomScrollView(
                            controller: scrollController,
                            slivers: [
                              SliverFillRemaining(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: Container(
                                        width: 40,
                                        height: 5,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withAlpha(100),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TabBar(
                                      physics: NeverScrollableScrollPhysics(),
                                      overlayColor: WidgetStatePropertyAll(
                                        const Color.fromARGB(221, 31, 103, 141),
                                      ),
                                      labelColor: Colors.white,
                                      unselectedLabelColor: Colors.grey,
                                      dividerColor: Colors.transparent,
                                      indicatorColor: Colors.white,
                                      tabs: [
                                        Tab(text: "UP NEXT"),
                                        Tab(text: "LYRICES"),
                                      ],
                                    ),
                                    Expanded(
                                      child: TabBarView(
                                        children: [
                                          Obx(
                                            () => GestureDetector(
                                              onVerticalDragDown: (details) {},
                                              child: ReorderableListView(
                                                onReorder:
                                                    (oldIndex, newIndex) {
                                                      final track = c.playList
                                                          .removeAt(oldIndex);
                                                      if (newIndex > oldIndex)
                                                        newIndex--;
                                                      c.playList.insert(
                                                        newIndex,
                                                        track,
                                                      );
                                                    },

                                                children: List.generate(c.playList.length, (
                                                  index,
                                                ) {
                                                  final track =
                                                      c.playList[index];
                                                  return Container(
                                                    key: ValueKey(
                                                      track.previewUrl,
                                                    ),
                                                    color:
                                                        track ==
                                                            homeCrl
                                                                .current
                                                                .value
                                                        ? const Color.fromARGB(
                                                            221,
                                                            56,
                                                            144,
                                                            192,
                                                          )
                                                        : const Color.fromARGB(
                                                            221,
                                                            31,
                                                            103,
                                                            141,
                                                          ),
                                                    child: ListTile(
                                                      onTap: () {
                                                        homeCrl.playTrack(
                                                          track,
                                                        );
                                                      },
                                                      leading: Stack(
                                                        children: [
                                                          Image.network(
                                                            track.albumCover,
                                                            width: 50,
                                                          ),
                                                          if (homeCrl
                                                                  .current
                                                                  .value ==
                                                              track)
                                                            Positioned.fill(
                                                              child: Container(
                                                                color: Colors
                                                                    .black45,
                                                                child: Icon(
                                                                  Icons
                                                                      .graphic_eq,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                      title: Text(
                                                        track.title,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      subtitle: Text(
                                                        '${track.artist} ${c.formatDuration(track.duration)}',
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      trailing:
                                                          ReorderableDelayedDragStartListener(
                                                            index: index,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.fromLTRB(
                                                                    8.0,
                                                                    8,
                                                                    0,
                                                                    8,
                                                                  ),
                                                              child: Icon(
                                                                Icons
                                                                    .drag_handle,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ),
                                          ),
                                          Center(child: Text("empty")),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
