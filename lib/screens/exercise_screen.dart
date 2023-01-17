import 'dart:async';

import 'package:fit_track/classes/exercise.dart';
import 'package:fit_track/components/exercise_video.dart';
import 'package:fit_track/components/set_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class ExerciseScreen extends StatefulWidget {
  Exercise exercise;
  Function saveWorkoutPlanList;

  ExerciseScreen(
      {Key? key, required this.exercise, required this.saveWorkoutPlanList})
      : super(key: key);

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  bool isTimerStart = true;
  int minutes = 0;
  int seconds = 0;
  int minutesInput = 0;
  int secondsInput = 0;

  Timer? timer;

  @override
  Widget build(BuildContext context) {
    List<Widget> setWidgets = [];
    if (widget.exercise.doneSets.isEmpty) {
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
                  "${widget.exercise.doneSets[0].date.day}.${widget.exercise.doneSets[0].date.month}.${widget.exercise.doneSets[0].date.year}",
                  style: GoogleFonts.montserrat(
                    color: Colors.grey.shade400,
                  )),
            ),
            Expanded(
              child: Divider(
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      );
      for (int i = 0; i < widget.exercise.doneSets.length; i++) {
        if (widget.exercise.doneSets.length == 1 || i == 0) {
          setWidgets.add(
            SetWidget(
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
          } else if (widget.exercise.doneSets[i].date.minute !=
              widget.exercise.doneSets[i - 1].date.minute) {
            setWidgets.add(
              Row(
                children: <Widget>[
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
                    ),
                  ),
                ],
              ),
            );
            setWidgets.add(
              SetWidget(
                  doneSet: widget.exercise.doneSets[i],
                  doneSets: widget.exercise.doneSets,
                  updateFunction: update),
            );
          }
        }
      }
    }
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
              color: Colors.grey.shade900,
              itemBuilder: (context) {
                return {"Open video link"}.map(
                  (item) {
                    return PopupMenuItem(
                      value: item,
                      onTap: () async {
                        var url =
                            'https://musclewiki.com/${widget.exercise.getLink()}';
                        final uri = Uri.parse(url);
                        var urllaunchable = await canLaunchUrl(uri);
                        if (urllaunchable) {
                          await launchUrl(uri);
                        } else {
                          print("URL can't be launched.");
                        }
                      },
                      child: Text(
                        item,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
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
                'https://musclewiki.com/media/uploads/videos/branded/male-${widget.exercise.getvideoLink()}-front.mp4#t=0.1',
              ),
              looping: true,
              autoplay: true,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
              margin: const EdgeInsets.fromLTRB(40, 8, 40, 21),
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
            Column(
              children: setWidgets.map((widget) => widget).toList(),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FloatingActionButton(
                heroTag: "btn1",
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          void onTick(Timer time) {
                            if (secondsInput <= 0 && minutesInput <= 0) {
                              setState(() {
                                isTimerStart = true;
                              });
                              timer?.cancel();
                            } else if (secondsInput <= 0 && minutesInput > 0) {
                              setState(() {
                                --minutesInput;
                                secondsInput = 59;
                              });
                            } else {
                              setState(() {
                                --secondsInput;
                              });
                            }
                          }

                          void stopTimer() {
                            setState(() => timer!.cancel());
                          }

                          void startTimer(int minutesInput, int secondsInput) {
                            minutesInput = minutes;
                            secondsInput = seconds;
                            timer = Timer.periodic(
                                const Duration(seconds: 1), onTick);
                          }

                          return AlertDialog(
                            title: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.alarm,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  Text(
                                    " Timer",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            backgroundColor: Colors.grey.shade900,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(Icons.arrow_drop_up,
                                        color: isTimerStart
                                            ? Colors.white38
                                            : Colors.grey.shade900),
                                    const SizedBox(width: 8),
                                    Icon(Icons.arrow_drop_up,
                                        color: isTimerStart
                                            ? Colors.white38
                                            : Colors.grey.shade900),
                                  ],
                                ),
                                const Divider(
                                  thickness: 1,
                                  color: Colors.white38,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    NumberPicker(
                                      textStyle: GoogleFonts.montserrat(
                                          color: Colors.white, fontSize: 25),
                                      selectedTextStyle: GoogleFonts.montserrat(
                                          color: Colors.white, fontSize: 25),
                                      itemWidth: 35,
                                      value: minutesInput,
                                      minValue: 0,
                                      maxValue: 59,
                                      step: 1,
                                      haptics: true,
                                      itemCount: 1,
                                      onChanged: (value) {
                                        setState(
                                          () {
                                            minutesInput = value;
                                          },
                                        );
                                      },
                                    ),
                                    Text(
                                      ':',
                                      style: GoogleFonts.montserrat(
                                          color: Colors.white, fontSize: 25),
                                    ),
                                    NumberPicker(
                                      textStyle: GoogleFonts.montserrat(
                                          color: Colors.white, fontSize: 25),
                                      selectedTextStyle: GoogleFonts.montserrat(
                                          color: Colors.white, fontSize: 25),
                                      itemWidth: 35,
                                      value: secondsInput,
                                      minValue: 0,
                                      maxValue: 59,
                                      step: 1,
                                      zeroPad: true,
                                      haptics: true,
                                      itemCount: 1,
                                      onChanged: (value) {
                                        isTimerStart
                                            ? setState(
                                                () {
                                                  secondsInput = value;
                                                },
                                              )
                                            : setState(
                                                () {},
                                              );
                                      },
                                    ),
                                  ],
                                ),
                                const Divider(
                                  thickness: 1,
                                  color: Colors.white38,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(Icons.arrow_drop_down,
                                        color: isTimerStart
                                            ? Colors.white38
                                            : Colors.grey.shade900),
                                    const SizedBox(width: 8),
                                    Icon(Icons.arrow_drop_down,
                                        color: isTimerStart
                                            ? Colors.white38
                                            : Colors.grey.shade900),
                                  ],
                                ),
                              ],
                            ),
                            actions: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        isTimerStart
                                            ? startTimer(minutes, seconds)
                                            : stopTimer();
                                        setState(
                                            () => isTimerStart = !isTimerStart);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: isTimerStart
                                              ? Colors.blue.shade900
                                              : Colors.red.shade900,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          isTimerStart ? "Start" : 'Stop',
                                          style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade900,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          "Close",
                                          style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
                backgroundColor: Colors.blue.shade900,
                elevation: 20,
                child: const Icon(Icons.alarm),
              ),
              FloatingActionButton(
                heroTag: "btn2",
                onPressed: () {
                  widget.exercise.addSet(0, 0);
                  update();
                },
                backgroundColor: Colors.blue.shade900,
                elevation: 20,
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ));
  }

  void update() {
    widget.saveWorkoutPlanList();
    setState(
      () {
        //print("Updated");
      },
    );
  }
}
