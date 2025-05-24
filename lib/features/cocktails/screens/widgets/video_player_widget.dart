import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cocteles_app/features/livestreams/models/livestream_model.dart';
import 'package:cocteles_app/features/perzonalization/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart'; // Provides [Player], [Media], [Playlist] etc.
import 'package:media_kit_video/media_kit_video.dart'; // Provides [VideoController] & [Video] etc.
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:file_picker/file_picker.dart';



class VideoPlayerWidget extends StatefulWidget {
  final String url;
  const VideoPlayerWidget({Key? key, required this.url}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late final Player player;
  late final VideoController controller;

  @override
  void initState() {
    super.initState();
    player     = Player();                   // core playback controller
    controller = VideoController(player);     // rendering bridge
    player.open(Media(widget.url));           // start loading your URL
  }

  @override
  void dispose() {
    player.dispose(); // releases all native handles
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // maintain your aspect ratio:
    final width  = MediaQuery.of(context).size.width;
    final height = width * 9/16;
    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: Video(controller: controller),  // Renders the stream
      ),
    );
  }
}
