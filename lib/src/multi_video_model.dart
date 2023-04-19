import 'package:video_player/video_player.dart';

enum VideoSource { network, file, asset }

class MultiVideo {
  /// holds current page index for preload preview
  static int currentIndex = 0;

  /// source for video network, file or asset
  dynamic videoSource;

  /// page index associated with video
  int index;

  /// video player controller
  VideoPlayerController? videoPlayerController;

  /// creates a video model
  /// [videoSource] must not be null
  MultiVideo(
      {required this.videoSource, this.videoPlayerController, this.index = 0});

  /// plays current video
  void playVideo(int index) {
    /// if [currentIndex] and video [index] matches while swiping through videos
    /// it plays the video
    if (index == currentIndex) {
      if (videoPlayerController != null) {
        videoPlayerController?.play();
      }
    }
  }

  /// updates [videoPlayerController], [videoSource] and [index] when video get initialized
  void updateVideo({videoSource, videoPlayerController, index}) {
    this.videoPlayerController = videoPlayerController;
    this.videoSource = videoSource;
    this.index = index;
  }
}
