import 'package:fit_track/classes/exercise.dart';
import 'package:fit_track/screens/exercise_screen.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

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
          children: [
            Text(
              widget.exercise.name,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                letterSpacing: 2,
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
                          // EDIT EXERCISE
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
