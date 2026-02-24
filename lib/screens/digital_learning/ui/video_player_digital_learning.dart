import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

import '../../../models/digital_learning/digital_learning_item.dart';

class VideoPlayerDigitalLearningUI extends StatefulWidget {
  static const routeName = '/videoPlayerDigitalLearning';
  final File file;
  final DigitalLearningItem item;
  final bool? skip;

  const VideoPlayerDigitalLearningUI({Key? key, required this.item, required this.file, this.skip}) : super(key: key);

  @override
  _VideoPlayerDigitalLearningUIState createState() => _VideoPlayerDigitalLearningUIState();
}

class _VideoPlayerDigitalLearningUIState extends State<VideoPlayerDigitalLearningUI> {
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
        _controller.play();
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
    DigitalLearningItem av = widget.item;

    return WillPopScope(
      onWillPop: () async {
        // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        return false;
      },
      child: GestureDetector(
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
                allowScrubbing: false,
              ),
            ),

            if (_controller.value.position == _controller.value.duration)
              Positioned(
                right: 5.w,
                top: 2.h,
                child: Material(
                  borderRadius: BorderRadius.circular(20.sp),
                  color: Colors.white24,
                  child: IconButton(
                    onPressed: () {
                      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
                      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                      Navigator.pop(context, true);
                    },
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
