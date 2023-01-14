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

List<Widget> setWidgets = [];

class _ExerciseScreenState extends State<ExerciseScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.exercise.doneSets.isEmpty) {
      setWidgets.clear();
      setWidgets.add(
        Row(
          children: <Widget>[
            Expanded(
              child: Divider(
                color: Colors.grey.shade400,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Please add your sets",
                style: GoogleFonts.montserrat(
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      );
    } else if (widget.exercise.doneSets.isNotEmpty) {
      setWidgets.clear();
      for (int i = 0; i < widget.exercise.doneSets.length; i++) {
        if (widget.exercise.doneSets.length == 1 || i == 0) {
          setWidgets.add( SetWidget(
              doneSet: widget.exercise.doneSets[0],
              doneSets: widget.exercise.doneSets,
              updateFunction: update),
          );
        } else if (widget.exercise.doneSets.length > 1) {
          if (widget.exercise.doneSets[i].date.minute ==
              widget.exercise.doneSets[i - 1].date.minute) {
            setWidgets.add(
              SetWidget(
                  doneSet: widget.exercise.doneSets[i],
                  doneSets: widget.exercise.doneSets,
                  updateFunction: update),
            );
          }else if (widget.exercise.doneSets[i].date.minute !=
              widget.exercise.doneSets[i - 1].date.minute){
            setWidgets.add(
              Row(children: <Widget>[
                Expanded(
                    child: Divider(
                      color: Colors.grey.shade400,
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                      "${widget.exercise.doneSets[i].date.day}.${widget.exercise.doneSets[i].date.month}.${widget.exercise.doneSets[i].date.year}",
                      style: GoogleFonts.montserrat(
                        color: Colors.grey.shade400,
                      )),
                ),
                Expanded(
                    child: Divider(
                      color: Colors.grey.shade400,
                    )),
              ]
              ),
            );
            setWidgets.add(SetWidget(
                doneSet: widget.exercise.doneSets[i],
                doneSets: widget.exercise.doneSets,
                updateFunction: update),
            );
          }
        }
      }
    }

    //
    // if (widget.exercise.doneSets.length == 1) {
    //   setWidgets.add(SetWidget(
    //       doneSet: widget.exercise.doneSets[widget.exercise.doneSets.length-1],
    //       doneSets: widget.exercise.doneSets,
    //       updateFunction: update));
    // } else if(widget.exercise.doneSets.length > 1) {
    //   print(setWidgets);
    //   for (int i = 0; i < widget.exercise.doneSets.length-1; i++) {
    //     if (widget.exercise.doneSets[i].date.minute ==
    //         widget.exercise.doneSets[i + 1].date.minute) {
    //       setWidgets.add(SetWidget(
    //           doneSet: widget.exercise.doneSets[i],
    //           doneSets: widget.exercise.doneSets,
    //           updateFunction: update));
    //     }
    //     else if(i==widget.exercise.doneSets.length-1){
    //       setWidgets.add(SetWidget(
    //           doneSet: widget.exercise.doneSets[i],
    //           doneSets: widget.exercise.doneSets,
    //           updateFunction: update));
    //     }
    //     else {
    //       setWidgets.add(
    //         Row(children: <Widget>[
    //           Expanded(
    //               child: Divider(
    //             color: Colors.grey.shade400,
    //           )),
    //           Padding(
    //             padding: const EdgeInsets.symmetric(horizontal: 16.0),
    //             child: Text(
    //                 "${widget.exercise.doneSets[i].date.day}.${widget.exercise.doneSets[i].date.month}.${widget.exercise.doneSets[i].date.year}",
    //                 style: GoogleFonts.montserrat(
    //                   color: Colors.grey.shade400,
    //                 )),
    //           ),
    //           Expanded(
    //               child: Divider(
    //             color: Colors.grey.shade400,
    //           )),
    //         ]
    //         ),
    //       );
    //       setWidgets.add(SetWidget(
    //           doneSet: widget.exercise.doneSets[i],
    //           doneSets: widget.exercise.doneSets,
    //           updateFunction: update),
    //       );
    //     }
    //   }
    // }
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fitness_center),
            const SizedBox(width: 5),
            Text(
              "FitTrack",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue.shade900,
        centerTitle: false,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return {"Delete Plan", "Change Plan Name"}.map(
                (item) {
                  return PopupMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: GoogleFonts.montserrat(
                        color:
                            item == "Delete Plan" ? Colors.red : Colors.white,
                      ),
                    ),
                  );
                },
              ).toList();
            },
          )
        ],
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
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
            decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(15)),
            child: Text(
              textAlign: TextAlign.center,
              'Target\nSet/Rep/Weight\n ${widget.exercise.targetSet} / ${widget.exercise.targetRep} / ${widget.exercise.targetWeight}',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                  letterSpacing: 4),
            ),
          ),
          const Divider(),
          Column(
            children:
                setWidgets.map((widget) => widget).toList(),
          ),
          // Center(
          //   child: TextButton(
          //     style: TextButton.styleFrom(
          //         backgroundColor: Colors.blue.shade900,
          //         foregroundColor: Colors.white),
          //     onPressed: () {
          //       widget.exercise.addSet(0, 0);
          //       update();
          //     },
          //     child: const Icon(Icons.add),
          //   ),
          // )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.exercise.addSet(0, 0);
          update();
        },
        backgroundColor: Colors.blue.shade900,
        elevation: 20,
        child: const Icon(Icons.add),
      ),
    );
  }

  void update() {
    setState(
      () {
        //print("Updated");
      },
    );
  }
}
