import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

import '../models/AvModel.dart';


class VideoPlayerUI extends StatefulWidget {
  static const routeName = '/videoPlayer';
  final File file;
  final AvModel avModel;
  final bool? skip;

  const VideoPlayerUI({Key? key, required this.avModel, required this.file, this.skip}) : super(key: key);

  @override
  _VideoPlayerUIState createState() => _VideoPlayerUIState();
}

class _VideoPlayerUIState extends State<VideoPlayerUI> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((value) {
        if (widget.avModel.autoplay == 1) {
          _controller.play();
        }
      });

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AvModel av = widget.avModel;

    return PopScope(
      canPop: false,
      child: SafeArea(
        child: GestureDetector(
          onTap: av.skippable == 1
              ? () {
                  _controller.value.isPlaying ? _controller.pause() : _controller.play();
                }
              : (_controller.value.position == _controller.value.duration)
                  ? () {
                      _controller.value.isPlaying ? _controller.pause() : _controller.play();
                    }
                  : () {},
          child: Stack(
            children: [
              ///the player
              Center(
                child: _controller.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                    : const CircularProgressIndicator(),
              ),

              /// the pause and play icon
              _controller.value.isPlaying
                  ? Container()
                  : Container(
                      alignment: Alignment.center,
                      color: Colors.black26,
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 40.sp,
                      ),
                    ),

              ///video timeline
              Container(
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(bottom: 3.h),
                child: VideoProgressIndicator(
                  _controller,
                  allowScrubbing: av.skippable == 1 ? true : false,
                ),
              ),

              (av.skippable == 1 || widget.skip == true)
                  ? Positioned(
                      right: 28,
                      top: 46,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.sp),
                        color: Colors.white24,
                        child: IconButton(
                          onPressed: () {
                            SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                            Navigator.pop(context, true);
                          },
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    )
                  : (_controller.value.position == _controller.value.duration)
                      ? Positioned(
                          right: 5.w,
                          top: 2.h,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.sp),
                            color: Colors.white24,
                            child: IconButton(
                              onPressed: () {
                                SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                                Navigator.pop(context, true);
                              },
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
