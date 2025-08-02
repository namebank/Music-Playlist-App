class DeezerTrack {
  final String title;
  final String artist;
  final String albumCover;
  final int duration;
  final String previewUrl;

  DeezerTrack({
    required this.title,
    required this.artist,
    required this.albumCover,
    required this.duration,
    required this.previewUrl,
  });

  factory DeezerTrack.fromJson(Map<String, dynamic> json) {
    return DeezerTrack(
      title: json['title'],
      artist: json['artist']['name'],
      albumCover: json['album']['cover'],
      duration: json['duration'],
      previewUrl: json['preview'],
    );
  }
}
