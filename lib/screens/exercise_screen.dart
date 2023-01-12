import 'package:fit_track/classes/set.dart';
import 'package:fit_track/components/exercise_video.dart';
import 'package:fit_track/components/set_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({Key? key}) : super(key: key);

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  @override
  Widget build(BuildContext context) {
    int targetSet = 5;
    int targetRep = 8;
    int targetWeight = 10;
    return Scaffold(
      body: ListView(
        children: <Widget>[
          ExerciseVideo(
            videoPlayerController: VideoPlayerController.network(
              'https://musclewiki.com/media/uploads/videos/branded/male-barbell-bench-press-front.mp4#t=0.1',
            ),
            looping: true,
            autoplay: true,
          ),
          const Divider(),
          Center(
            child: Text(
              'Target Set/Rep/Weight: $targetRep/$targetSet/$targetWeight',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
          const Divider(),
          const SetWidget(),
          Center(
            child: TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.blue.shade900,
                  foregroundColor: Colors.white),
              onPressed: () {
                setState(() {
                  // doneSets.add(set());
                });
              },
              child: const Icon(Icons.add),
            ),
          )
        ],
      ),
    );
  }
}
