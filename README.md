
## Multi Video Player

Play multiple preloaded videos just by providing list of video sources.

![Sample](https://github.com/punit1111/multi_video_player/blob/main/doc/preview.gif)

## Example

`
    MultiVideoPlayer.asset(
        videoSourceList: videos,
        scrollDirection: Axis.horizontal,
        preloadPagesCount: 2,
        onPageChanged: (videoPlayerController, index) {},
        getCurrentVideoController: (videoPlayerController) {},
    ),
`
Use ScrollConfiguration if scrolling not work for WEB.

```
    ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: MultiVideoPlayer.asset(
          videoSourceList: videos,
          scrollDirection: Axis.horizontal,
          preloadPagesCount: 2,
          onPageChanged: (videoPlayerController, index) {},
          getCurrentVideoController: (videoPlayerController) {},
        ),
    ),
```
