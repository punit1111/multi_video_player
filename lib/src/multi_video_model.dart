import 'package:video_player/video_player.dart';

enum VideoSource { network, file, asset }

class MultiVideo {
  static int currentIndex = 0;
  dynamic videoSource;
  int index;
  VideoPlayerController? videoPlayerController;
  MultiVideo(
      {required this.videoSource, this.videoPlayerController, this.index = 0});

  void playVideo(int index) {
    if (index == currentIndex) {
      if (videoPlayerController != null) {
        videoPlayerController?.play();
      }
    }
  }

  void updateVideo({videoSource, videoPlayerController, index}) {
    this.videoPlayerController = videoPlayerController;
    this.videoSource = videoSource;
    this.index = index;
  }
}
