import 'package:flutter/material.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:video_player/video_player.dart';

import 'multi_video_item.dart';
import 'multi_video_model.dart';

//ignore: must_be_immutable
class MultiVideoPlayer extends StatefulWidget {
  VideoSource sourceType;
  List<dynamic> videoSourceList;
  Axis scrollDirection;
  int preloadPagesCount;
  VideoPlayerOptions? videoPlayerOptions;
  Future<ClosedCaptionFile>? closedCaptionFile;
  Map<String, String>? httpHeaders;
  VideoFormat? formatHint;
  String? package;
  Function(VideoPlayerController? videoPlayerController)?
      getCurrentVideoController;
  Function(VideoPlayerController? videoPlayerController, int index)?
      onPageChanged;
  ScrollPhysics? scrollPhysics;
  bool reverse;
  bool pageSnapping;
  PreloadPageController? pageController;

  @override
  State<MultiVideoPlayer> createState() => _MultiVideoPlayerState();

  MultiVideoPlayer.network({
    super.key,
    required this.videoSourceList,
    this.scrollDirection = Axis.horizontal,
    this.preloadPagesCount = 1,
    this.videoPlayerOptions,
    this.httpHeaders,
    this.formatHint,
    this.closedCaptionFile,
    this.scrollPhysics,
    this.reverse = false,
    this.pageSnapping = true,
    this.pageController,
    this.getCurrentVideoController,
    this.onPageChanged,
  }) : sourceType = VideoSource.network;

  MultiVideoPlayer.file({
    super.key,
    required this.videoSourceList,
    this.scrollDirection = Axis.horizontal,
    this.preloadPagesCount = 1,
    this.videoPlayerOptions,
    this.httpHeaders,
    this.closedCaptionFile,
    this.scrollPhysics,
    this.reverse = false,
    this.pageSnapping = true,
    this.pageController,
    this.getCurrentVideoController,
    this.onPageChanged,
  }) : sourceType = VideoSource.file;

  MultiVideoPlayer.asset({
    super.key,
    required this.videoSourceList,
    this.scrollDirection = Axis.horizontal,
    this.preloadPagesCount = 1,
    this.videoPlayerOptions,
    this.package,
    this.closedCaptionFile,
    this.scrollPhysics,
    this.reverse = false,
    this.pageSnapping = true,
    this.pageController,
    this.getCurrentVideoController,
    this.onPageChanged,
  }) : sourceType = VideoSource.asset;
}

class _MultiVideoPlayerState extends State<MultiVideoPlayer> {
  bool isLoading = true;
  List<MultiVideo> videosList = [];

  @override
  void initState() {
    super.initState();
    _generateVideoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: videosList.isEmpty
          ? const Center(child: Icon(Icons.error))
          : isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : _pageView(),
    );
  }

  PreloadPageView _pageView() {
    return PreloadPageView.builder(
      itemCount: videosList.length,
      physics: widget.scrollPhysics,
      reverse: widget.reverse,
      controller: widget.pageController,
      pageSnapping: widget.pageSnapping,
      scrollDirection: widget.scrollDirection,
      preloadPagesCount: widget.preloadPagesCount > videosList.length
          ? 1
          : widget.preloadPagesCount,
      onPageChanged: (int index) => _onPageChange(index),
      itemBuilder: (context, index) => _child(index),
    );
  }

  MultiVideoItem _child(int index) {
    return MultiVideoItem(
      videoSource: videosList[index].videoSource,
      index: index,
      sourceType: widget.sourceType,
      videoPlayerOptions: widget.videoPlayerOptions,
      closedCaptionFile: widget.closedCaptionFile,
      onInit: (VideoPlayerController videoPlayerController) {
        if (index == MultiVideo.currentIndex) {
          widget.getCurrentVideoController?.call(videoPlayerController);
        }
        videosList[index].updateVideo(
            videoPlayerController: videoPlayerController,
            index: index,
            videoSource: videosList[index].videoSource);
      },
      onDispose: (int index) {
        videosList[index].videoPlayerController = null;
      },
    );
  }

  _onPageChange(int index) {
    MultiVideo.currentIndex = index;
    widget.getCurrentVideoController
        ?.call(videosList[index].videoPlayerController);
    widget.onPageChanged?.call(videosList[index].videoPlayerController, index);
    videosList[index].playVideo(index);
  }

  Future<void> _generateVideoList() async {
    await Future.forEach(widget.videoSourceList, (source) async {
      videosList.add(MultiVideo(videoSource: source));
    });
    if (mounted) {
      setState(() => isLoading = false);
    }
  }
}
