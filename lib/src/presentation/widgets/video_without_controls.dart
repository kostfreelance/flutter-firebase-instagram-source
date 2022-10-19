import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_firebase_instagram/src/presentation/app_colors.dart';

class VideoWithoutControlsWidget extends StatefulWidget {
  final dynamic child;
  final double width;
  final double height;

  const VideoWithoutControlsWidget({
    Key? key,
    required this.child,
    required this.width,
    required this.height
  }) : super(key: key);

  @override
  VideoWithoutControlsWidgetState createState() => VideoWithoutControlsWidgetState();
}

class VideoWithoutControlsWidgetState extends State<VideoWithoutControlsWidget> {
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = (widget.child is String) ?
      VideoPlayerController.network(widget.child) :
      VideoPlayerController.file(widget.child);
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
            right: 5.r,
            top: 5.r,
            child: Icon(
              Icons.play_arrow,
              color: AppColors.white.withOpacity(0.7),
              size: 25.r
            )
          )
        ]
      ) :
      Container();
  }
}