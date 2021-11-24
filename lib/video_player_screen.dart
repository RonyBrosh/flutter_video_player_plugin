import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({Key? key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  final platform = const MethodChannel("ronybrosh.video_player/isReducedMotionEnabled");

  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.asset("assets/video_induction_screen.mp4");
    _videoPlayerController.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.amber,
        ),
        FutureBuilder(
          future: _initVideo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
              final bool isLoadVideoSuccessful = snapshot.data as bool;
              if (isLoadVideoSuccessful) {
                return VideoPlayer(_videoPlayerController);
              } else {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Reduced motion is enabled.\nVideo won't play",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ],
    );
  }

  Future<bool> _initVideo() async {
    await Future.delayed(const Duration(seconds: 2));
    final bool isReducedMotionEnabled = await platform.invokeMethod("isReducedMotionEnabled");
    print("isReducedMotionEnabled = $isReducedMotionEnabled");
    if (isReducedMotionEnabled) {
      return false;
    } else {
      return _videoPlayerController.initialize().then((_) {
        print("_initVideo succeeded");
        _videoPlayerController.play();
        return true;
      }).onError((error, stackTrace) {
        print("_initVideo failed: $error");
        return false;
      });
    }
  }
}
