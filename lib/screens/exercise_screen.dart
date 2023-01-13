import 'package:fit_track/classes/exercise.dart';
import 'package:fit_track/components/exercise_video.dart';
import 'package:fit_track/components/set_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class ExerciseScreen extends StatefulWidget {
  Exercise exercise;
  ExerciseScreen({Key? key, required this.exercise}) : super(key: key);

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  @override
  void initState() {
    super.initState();
    widget.exercise.addSet(15, 20);
    widget.exercise.addSet(16, 21);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> setWidgets = [];
    for (var i = 0; i < widget.exercise.doneSets.length - 1; i++) {
      if (i == 0) {
        setWidgets.add(SetWidget(
            rep: widget.exercise.doneSets[i].rep,
            weight: widget.exercise.doneSets[i].weight));
        if (widget.exercise.doneSets[i].date.day ==
            widget.exercise.doneSets[i + 1].date.day) {
          setWidgets.add(SetWidget(
              rep: widget.exercise.doneSets[i + 1].rep,
              weight: widget.exercise.doneSets[i + 1].weight));
        }
      } else if (widget.exercise.doneSets[i].date.day ==
          widget.exercise.doneSets[i + 1].date.day) {
        setWidgets.add(SetWidget(
            rep: widget.exercise.doneSets[i + 1].rep,
            weight: widget.exercise.doneSets[i + 1].weight));
      } else {
        setWidgets.add(const Divider());
        setWidgets.add(SetWidget(
            rep: widget.exercise.doneSets[i + 1].rep,
            weight: widget.exercise.doneSets[i + 1].weight));
      }
    }
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      appBar: AppBar(
        title: Text(
          "FitTrack",
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.blue.shade900,
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          ExerciseVideo(
            videoPlayerController: VideoPlayerController.network(
              'https://musclewiki.com/media/uploads/videos/branded/male-${widget.exercise.getLink()}-front.mp4#t=0.1',
            ),
            looping: true,
            autoplay: true,
          ),
          const Divider(),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
                color: Colors.blue.shade900,
                borderRadius: BorderRadius.circular(55)),
            child: Text(
              textAlign: TextAlign.center,
              'Target\n Set/Rep/Weight:\n ${widget.exercise.targetSet}/${widget.exercise.targetRep}/${widget.exercise.targetWeight}',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                  letterSpacing: 4),
            ),
          ),
          const Divider(),
          Column(
            children: setWidgets.map((widget) => widget).toList(),
          ),
          Center(
            child: TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.blue.shade900,
                  foregroundColor: Colors.white),
              onPressed: () {
                setState(() {
                  widget.exercise.addSet(0, 0);
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
