import 'package:fit_track/classes/exercise.dart';
import 'package:fit_track/screens/exercise_screen.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:numberpicker/numberpicker.dart';

class ExerciseWidget extends StatefulWidget {
  Exercise exercise;
  List<Exercise> exerciseList;
  Function updateFunction;

  ExerciseWidget({
    super.key,
    required this.exercise,
    required this.exerciseList,
    required this.updateFunction,
  });

  @override
  State<ExerciseWidget> createState() => _ExerciseWidgetState();
}

class _ExerciseWidgetState extends State<ExerciseWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ExerciseScreen(
                    exercise: widget.exercise,
                    saveWorkoutPlanList: widget.updateFunction,
                  )),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.blue.shade900,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                widget.exercise.name,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: PopupMenuButton(
                    itemBuilder: (context) {
                      return {"Edit", "Delete"}.map((item) {
                        return PopupMenuItem(
                          value: item,
                          child: Text(
                            item,
                            style: GoogleFonts.montserrat(
                              color:
                                  item == "Delete" ? Colors.red : Colors.white,
                            ),
                          ),
                        );
                      }).toList();
                    },
                    onSelected: (value) {
                      switch (value) {
                        case "Edit":
                          showDialog(
                            context: context,
                            builder: (context) {
                              int targetSetCount = widget.exercise.targetSet;
                              int targetRepCount = widget.exercise.targetRep;
                              int targetWeightCount1 = int.parse(widget.exercise.targetWeight.toString().split('.')[0]);
                              int targetWeightCount2 = int.parse(widget.exercise.targetWeight.toString().split('.')[1]);
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    title: Text(
                                      "Add Exercise",
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    backgroundColor: Colors.grey.shade900,
                                    titlePadding: const EdgeInsets.all(24),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                                    actionsPadding: const EdgeInsets.all(24),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Set",
                                          style: GoogleFonts.montserrat(
                                            color: Colors.white
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.arrow_left, color: Colors.white38),
                                            NumberPicker(
                                              minValue: 1,
                                              maxValue: 99,
                                              value: targetSetCount,
                                              onChanged: (value) {
                                                setState(() {
                                                  targetSetCount = value;
                                                });
                                              },
                                              selectedTextStyle: GoogleFonts.montserrat(
                                                color: Colors.blue.shade900,
                                                fontSize: 32,
                                              ),
                                              itemCount: 1,
                                              axis: Axis.horizontal,
                                              itemWidth: 45,
                                            ),
                                            const Icon(Icons.arrow_right, color: Colors.white38),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          "Rep x Weight",
                                          style: GoogleFonts.montserrat(
                                            color: Colors.white
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Icon(Icons.arrow_drop_up, color: Colors.white38),
                                        const Divider(
                                          thickness: 1,
                                          color: Colors.white38,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            NumberPicker(
                                              minValue: 1,
                                              maxValue: 99,
                                              value: targetRepCount,
                                              onChanged: (value) {
                                                setState(() {
                                                  targetRepCount = value;
                                                });
                                              },
                                              selectedTextStyle: GoogleFonts.montserrat(
                                                color: Colors.blue.shade900,
                                                fontSize: 32,
                                              ),
                                              itemCount: 1,
                                              itemWidth: 65,
                                            ),
                                            const Icon(
                                              Icons.close,
                                              color: Colors.white38,
                                            ),
                                            NumberPicker(
                                              minValue: 0,
                                              maxValue: 500,
                                              value: targetWeightCount1,
                                              onChanged: (value) {
                                                setState(() {
                                                  targetWeightCount1 = value;
                                                });
                                              },
                                              selectedTextStyle: GoogleFonts.montserrat(
                                                color: Colors.blue.shade900,
                                                fontSize: 32,
                                              ),
                                              itemCount: 1,
                                              itemWidth: 65,
                                            ),
                                            Text(
                                              ",",
                                              style: GoogleFonts.montserrat(
                                                color: Colors.white38,
                                                fontSize: 32,
                                              ),
                                            ),
                                            NumberPicker(
                                              minValue: 0,
                                              maxValue: 99,
                                              step: 25,
                                              infiniteLoop: true,
                                              zeroPad: true,
                                              value: targetWeightCount2 == 5 ? 50 : targetWeightCount2,
                                              onChanged: (value) {
                                                setState(() {
                                                  targetWeightCount2 = value;
                                                });
                                              },
                                              selectedTextStyle: GoogleFonts.montserrat(
                                                color: Colors.blue.shade900,
                                                fontSize: 32,
                                              ),
                                              itemCount: 1,
                                              itemWidth: 65,
                                            ),
                                            Text(
                                              "KG",
                                              style: GoogleFonts.montserrat(
                                                color: Colors.white38,
                                              ),
                                            )
                                          ],
                                        ),
                                        const Divider(
                                          thickness: 1,
                                          color: Colors.white38,
                                        ),
                                        const Icon(Icons.arrow_drop_down, color: Colors.white38),
                                      ],
                                    ),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
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
                                                "Cancel",
                                                style: GoogleFonts.montserrat(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              widget.exercise.targetSet = targetSetCount;
                                              widget.exercise.targetRep = targetRepCount;
                                              widget.exercise.targetWeight = double.parse("$targetWeightCount1.$targetWeightCount2");
                                              widget.updateFunction();
                                              Navigator.of(context).pop();
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 8),
                                              decoration: BoxDecoration(
                                                color: Colors.blue.shade900,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                "Save",
                                                style: GoogleFonts.montserrat(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            });
                          break;
                        case "Delete":
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Colors.grey.shade900,
                                title: Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Text(
                                    "Delete?",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                content: Text(
                                  "Are you sure you want to delete selected exercise and all of its information? (This process cannot be undone.)",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Cancel",
                                      style: GoogleFonts.montserrat(
                                        color: Colors.blue.shade900,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: TextButton(
                                      onPressed: () {
                                        widget.exerciseList.removeWhere(
                                            (element) =>
                                                element.uuid ==
                                                widget.exercise.uuid);
                                        widget.updateFunction();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Delete",
                                        style: GoogleFonts.montserrat(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                          break;
                      }
                    },
                    color: Colors.grey.shade900,
                    child: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      int index = widget.exerciseList.indexWhere(
                          (element) => element.uuid == widget.exercise.uuid);
                      if (index == 0) {
                        return;
                      }
                      Exercise temp = widget.exerciseList[index - 1];
                      widget.exerciseList[index - 1] =
                          widget.exerciseList[index];
                      widget.exerciseList[index] = temp;
                      widget.updateFunction();
                    },
                    child: const Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    int index = widget.exerciseList.indexWhere(
                        (element) => element.uuid == widget.exercise.uuid);
                    if (index == widget.exerciseList.length - 1) {
                      return;
                    }
                    Exercise temp = widget.exerciseList[index + 1];
                    widget.exerciseList[index + 1] = widget.exerciseList[index];
                    widget.exerciseList[index] = temp;
                    widget.updateFunction();
                  },
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
