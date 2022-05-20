// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodnet_01/util/constants/images.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MediaWidget extends StatefulWidget {
  late String url;
  bool? isNet;
  BoxFit? fit;

  MediaWidget({Key? key, required this.url, this.isNet = true, this.fit=BoxFit.contain})
      : super(key: key);

  @override
  State<MediaWidget> createState() {
    switch (file_type(url)) {
      case 'mp4':
        return _VideoState();
      default:
        return _ImgState();
    }
  }
}

class _ImgState extends State<MediaWidget> {

  @override
  Widget build(BuildContext context) {
    if (widget.isNet == null) {
      return FittedBox(
          fit: BoxFit.contain,
          child: Image.network(widget.url, fit: widget.fit,
          errorBuilder: (BuildContext a, Object b, StackTrace? c) {
        try {
          var m = File(widget.url);
          return  Image.file(
            File(widget.url),
            fit: widget.fit,
            errorBuilder: (BuildContext a, Object b, StackTrace? c) =>
                FittedBox(
                  fit: BoxFit.contain,
                  child: Image.asset(placeholder,fit:widget.fit,)),
          );
        } catch (e) {
          print("this is an exception ${e.toString()}");
          return Image.asset(placeholder, fit: widget.fit,);
        }
      }));
    }
    if (!widget.isNet!) {
      try {
        var m = File(widget.url);
        return Image.file(
          File(widget.url),
          fit: BoxFit.cover,
          errorBuilder: (BuildContext a, Object b, StackTrace? c) =>
              Image.asset(placeholder, fit:widget.fit,),
        );
      } catch (e) {
        print("this is an exception ${e.toString()}");
        return Image.asset(placeholder, fit: widget.fit,);
      }
    }
    return  Image.network(
      widget.url,
      fit: BoxFit.cover,
      errorBuilder: (BuildContext a, Object b, StackTrace? c) =>
          Image.asset(placeholder,fit: widget.fit,),
    );
  }
}

class _VideoState extends State<MediaWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.isNet != null) {
      _controller = widget.isNet!
          ? VideoPlayerController.network(
              widget.url,
              videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
            )
          : VideoPlayerController.file(
              File(widget.url),
              videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
            );
    } else {
      try {
        _controller = VideoPlayerController.network(
          widget.url,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        );
      } catch (e) {
        _controller = VideoPlayerController.file(
          File(widget.url),
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        );
      }
    }
    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize();
    _controller.setVolume(1.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
        key: ObjectKey(_controller),
        onVisibilityChanged: (visibility) {
          if (visibility.visibleFraction == 0 && mounted) {
            _controller.pause(); //pausing  functionality
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      VideoPlayer(_controller),
                      _ControlsOverlay(controller: _controller),
                      VideoProgressIndicator(_controller, allowScrubbing: true),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key? key, required this.controller})
      : super(key: key);

  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 50,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _examplePlaybackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}
