import 'dart:math';

import 'package:fit_track/classes/workout_plan.dart';
import 'package:fit_track/components/exercise_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

List<WorkoutPlan> workoutPlanList = [WorkoutPlan(name: "Push Day")];

class _HomePageState extends State<HomePage> {
  String welcomeText = "Welcome!";
  String? selectedWorkoutPlanId;
  WorkoutPlan? selectedWorkoutPlan;

  TextEditingController addWorkoutTextController = TextEditingController();
  TextEditingController changeWorkoutTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getWelcomeText().then((value) => setState(() {
          welcomeText = value;
        }));
    workoutPlanList[0].addExercise("Barbell Bench Press", 5, 5, 80);
    workoutPlanList[0].addExercise("Dumbbell Lateral Raise", 4, 12, 12.5);
    workoutPlanList[0].addExercise("Dumbbell Skullcrusher", 4, 12, 25);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        centerTitle: true,
        leading: TextButton(
          onPressed: () {
            // OPEN PROFILE PAGE
          },
          child: const Icon(
            Icons.account_circle,
            color: Colors.white,
          ),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return {"Delete Plan", "Change Plan Name"}.map((item) {
                return PopupMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: GoogleFonts.montserrat(
                      color: item == "Delete Plan" ? Colors.red : Colors.white,
                    ),
                  ),
                );
              }).toList();
            },
            onSelected: (value) {
              if (selectedWorkoutPlanId == null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    "Please select a active workout plan.",
                    style: GoogleFonts.montserrat(),
                  ),
                  action: SnackBarAction(
                      label: 'OK!',
                      onPressed: ScaffoldMessenger.of(context).clearSnackBars,
                      textColor: Colors.blue.shade900),
                ));
                return;
              }
              switch (value) {
                case "Delete Plan":
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
                          "Are you sure you want to delete selected workout plan and all of its information? (This process cannot be undone.)",
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
                                setState(() {
                                  workoutPlanList.removeWhere((element) =>
                                      element.uuid == selectedWorkoutPlanId);
                                  selectedWorkoutPlanId = null;
                                  selectedWorkoutPlan = null;
                                });
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
                case "Change Plan Name":
                  showDialog(
                      context: context,
                      builder: (context) {
                        changeWorkoutTextController.text =
                            selectedWorkoutPlan!.name;
                        bool isWorkoutNameChangeButtonEnabled = true;
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  "Change Workout Plan Name",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              backgroundColor: Colors.grey.shade900,
                              content: TextField(
                                controller: changeWorkoutTextController,
                                onChanged: (value) {
                                  if (value.isEmpty) {
                                    setState(() {
                                      isWorkoutNameChangeButtonEnabled = false;
                                    });
                                  } else {
                                    setState(() {
                                      isWorkoutNameChangeButtonEnabled = true;
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: "Give a name",
                                  filled: true,
                                  fillColor: Colors.grey.shade800,
                                  hintStyle: GoogleFonts.montserrat(
                                    color: Colors.white54,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 2),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue.shade900, width: 2),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                style:
                                    GoogleFonts.montserrat(color: Colors.white),
                              ),
                              actions: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                          if (changeWorkoutTextController
                                              .text.isNotEmpty) {
                                            selectedWorkoutPlan!.name =
                                                changeWorkoutTextController
                                                    .text;
                                            Navigator.of(context).pop();
                                            update();
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          decoration: BoxDecoration(
                                            color:
                                                isWorkoutNameChangeButtonEnabled
                                                    ? Colors.blue.shade900
                                                    : Colors.grey.shade800,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            "Change",
                                            style: GoogleFonts.montserrat(
                                              color:
                                                  isWorkoutNameChangeButtonEnabled
                                                      ? Colors.white
                                                      : Colors.grey,
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
                      });
                  break;
              }
            },
            color: Colors.grey.shade900,
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade900,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            margin: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
                color: Colors.blue.shade900,
                borderRadius: BorderRadius.circular(15)),
            child: Text(
              welcomeText,
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: Colors.white,
                  letterSpacing: 4),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(30)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: selectedWorkoutPlanId,
                        items: workoutPlanList
                            .map((workoutPlan) => DropdownMenuItem(
                                  value: workoutPlan.uuid,
                                  child: Text(
                                    workoutPlan.name,
                                    style: GoogleFonts.montserrat(),
                                  ),
                                ))
                            .toList(),
                        hint: Text(
                          "Select a Workout Plan",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(),
                        ),
                        disabledHint: Text(
                          "First, create a Workout Plan",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectedWorkoutPlanId = value;
                            selectedWorkoutPlan = workoutPlanList.firstWhere(
                                (workoutPlan) =>
                                    workoutPlan.uuid == selectedWorkoutPlanId);
                          });
                        },
                        isExpanded: true,
                        iconSize: 32,
                        iconEnabledColor: Colors.grey.shade500,
                        iconDisabledColor: Colors.red,
                        dropdownColor: Colors.grey.shade800,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          bool isWorkoutAddButtonEnabled = false;
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                title: Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Text(
                                    "Add Workout Plan",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                backgroundColor: Colors.grey.shade900,
                                content: TextField(
                                  controller: addWorkoutTextController,
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      setState(() {
                                        isWorkoutAddButtonEnabled = false;
                                      });
                                    } else {
                                      setState(() {
                                        isWorkoutAddButtonEnabled = true;
                                      });
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Give a name",
                                    filled: true,
                                    fillColor: Colors.grey.shade800,
                                    hintStyle: GoogleFonts.montserrat(
                                      color: Colors.white54,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.white, width: 2),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue.shade900,
                                          width: 2),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white),
                                ),
                                actions: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            addWorkoutTextController.clear();
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
                                            if (addWorkoutTextController
                                                .text.isNotEmpty) {
                                              workoutPlanList.add(WorkoutPlan(
                                                  name: addWorkoutTextController
                                                      .text));
                                              addWorkoutTextController.clear();
                                              Navigator.of(context).pop();
                                              update();
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: isWorkoutAddButtonEnabled
                                                  ? Colors.blue.shade900
                                                  : Colors.grey.shade800,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              "Add",
                                              style: GoogleFonts.montserrat(
                                                color: isWorkoutAddButtonEnabled
                                                    ? Colors.white
                                                    : Colors.grey,
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
                        });
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: selectedWorkoutPlan == null
                  ? Column()
                  : SingleChildScrollView(
                      child: Column(
                        children: selectedWorkoutPlan!.exerciseList.isEmpty
                            ? [
                                Text(
                                  "This workout program is empty.\nTry to add new exercises using plus sign on the bottom right.",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade500,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              ]
                            : selectedWorkoutPlan!.exerciseList
                                .map((exercise) => ExerciseWidget(
                                      exercise: exercise,
                                      exerciseList:
                                          selectedWorkoutPlan!.exerciseList,
                                      updateFunction: update,
                                    ))
                                .toList(),
                      ),
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // CREATE EXERCISE
        },
        backgroundColor: Colors.blue.shade900,
        elevation: 20,
        child: const Icon(Icons.add),
      ),
    );
  }

  void update() {
    setState(() {
      //print("Updated");
    });
  }

  Future<String> getWelcomeText() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    List<String>? toDoStringList =
        sharedPreferences.getStringList('toDoStringList');
    if (toDoStringList != null) {
      int randomInt = Random().nextInt(2);
      if (randomInt == 1) {
        DateTime dt = DateTime.now();
        int hour = dt.hour;
        if (hour >= 5 && hour < 12) {
          return "Good\nMorning!";
        } else if (hour >= 12 && hour < 17) {
          return "Good\nAfternoon!";
        } else if (hour >= 17 && hour < 21) {
          return "Good\nEvening!";
        } else if (hour >= 21 && hour <= 24 || hour < 5) {
          return "Good\nNight!";
        }
      } else {
        return "Welcome\nBack!";
      }
    }
    return "Welcome!";
  }
}
