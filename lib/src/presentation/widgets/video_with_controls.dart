import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_firebase_instagram/src/presentation/app_colors.dart';
import 'app_button.dart';

class VideoWithControlsWidget extends StatefulWidget {
  final String url;
  final double width;
  final double height;

  const VideoWithControlsWidget({
    Key? key,
    required this.url,
    required this.width,
    required this.height
  }) : super(key: key);

  @override
  VideoWithControlsWidgetState createState() => VideoWithControlsWidgetState();
}

class VideoWithControlsWidgetState extends State<VideoWithControlsWidget> {
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.url);
    _videoPlayerController!.setLooping(true);
    _videoPlayerController!.play();
    _videoPlayerController!.initialize().then((_) =>
      setState(() {})
    );
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (_videoPlayerController != null) ?
      Stack(
        children: [
          _videoPlayerController!.value.isInitialized ?
            SizedBox(
              width: widget.width,
              height: widget.height,
              child: FittedBox(
                clipBehavior: Clip.hardEdge,
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoPlayerController!.value.size.width,
                  height: _videoPlayerController!.value.size.height,
                  child: VideoPlayer(_videoPlayerController!)
                ),
              ),
            ) :
            Container(
              width: widget.width,
              height: widget.height,
              color: AppColors.black
            ),
          Positioned(
            right: widget.width / 2 - 30.r,
            top: widget.height / 2 - 30.r,
            child: AppButton(
              child: Icon(
                _videoPlayerController!.value.isPlaying ?
                  Icons.pause :
                  Icons.play_arrow,
                color: AppColors.white.withOpacity(0.5),
                size: 60.r
              ),
              onPressed: () {
                setState(() {
                  _videoPlayerController!.value.isPlaying ?
                    _videoPlayerController!.pause() :
                    _videoPlayerController!.play();
                });
              }
            )
          )
        ]
      ) :
      Container();
  }
}