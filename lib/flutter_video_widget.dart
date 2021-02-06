library flutter_video_widget;
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// A  Video Widget
class VideoWidget extends StatefulWidget {
  String url;
  VideoWidgetOptions options = VideoWidgetOptions();
  bool isNetwork;
  bool isAsset;
  bool isFile;
  File file;
  VideoWidget.network({@required this.url, this.options}) : this.isNetwork = true, assert(url!=null);

  VideoWidget.file({@required this.file,this.options}) : this.isFile = true, assert(file!=null);

  VideoWidget.asset({@required  this.url, this.options}) : this.isAsset = true, assert(url!= null);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {

  VideoPlayerController videoPlayerController;
  Widget playerWidget;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeVideo();
  }

  initializeVideo() async {
      if(widget.isNetwork){
      videoPlayerController = VideoPlayerController.network(widget.url);
      } else if(widget.isAsset) {
      videoPlayerController = VideoPlayerController.asset(widget.url);
      } else if(widget.isFile) {
      videoPlayerController = VideoPlayerController.file(widget.file);
      }

      await videoPlayerController.initialize();

      final chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: widget.options.autoplay,
        looping: widget.options.looping
      );

      playerWidget = Chewie(
      controller: chewieController,
      );
  }

  @override
  Widget build(BuildContext context) {
    return playerWidget;
  }
}

class VideoWidgetOptions {
  double aspectRatio = 16.4;
  bool autoplay = true;
  bool looping = true;
  VideoWidgetOptions({this.aspectRatio, this.autoplay, this.looping});
}
