import 'dart:convert';
import 'dart:math';
import 'dart:developer' as dev;

import 'package:fit_track/classes/workout_plan.dart';
import 'package:fit_track/components/exercise_widget.dart';
import 'package:fit_track/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<WorkoutPlan> workoutPlanList = [];
  Map<String, List<String>> excel = {
    'Chest': ['Barbell Bench Press', 'Dumbbell Incline Bench Press'],
    'Shoulder': ['Dumbbell Lateral Raise', 'Dumbbell Seated Overhead Press'],
    'Triceps': ['Dumbbell Skullcrusher', 'Dips'],
  };
  
  String welcomeText = "Welcome!";
  String? selectedWorkoutPlanId;
  WorkoutPlan? selectedWorkoutPlan;

  TextEditingController addWorkoutTextController = TextEditingController();
  TextEditingController changeWorkoutTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getWorkoutPlanList().then((value) => setState(() {
          workoutPlanList = value;
        }));
    getWelcomeText().then((value) => setState(() {
          welcomeText = value;
        }));
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
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ProfilePage()),
            );
          },
          child: const Icon(
            Icons.account_circle,
            color: Colors.white,
          ),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return {"Change Plan Name", "Delete Plan"}.map((item) {
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
                        titlePadding: const EdgeInsets.all(24),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                        actionsPadding: const EdgeInsets.all(8),
                        title: Text(
                          "Delete?",
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
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
                                saveWorkoutPlanList();
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
                              title: Text(
                                "Change Workout Plan Name",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              backgroundColor: Colors.grey.shade900,
                              titlePadding: const EdgeInsets.all(24),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                              actionsPadding: const EdgeInsets.all(24),
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
                                  hintStyle: GoogleFonts.montserrat(
                                    color: Colors.white38,
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue.shade900,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                style:
                                    GoogleFonts.montserrat(color: Colors.white),
                              ),
                              actions: [
                                Row(
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
                                          saveWorkoutPlanList();
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
              textAlign: TextAlign.center,
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
                                title: Text(
                                  "Add Workout Plan",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                backgroundColor: Colors.grey.shade900,
                                titlePadding: const EdgeInsets.all(24),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                                actionsPadding: const EdgeInsets.all(24),
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
                                    hintStyle: GoogleFonts.montserrat(
                                      color: Colors.white38,
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blue.shade900,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white),
                                ),
                                actions: [
                                  Row(
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
                                            saveWorkoutPlanList();
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
          if (selectedWorkoutPlan == null) {
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
          showDialog(
            context: context,
            builder: (context) {
              String? selectedBodyPart;
              String? selectedExerciseName;
              int targetSetCount = 4;
              int targetRepCount = 12;
              int targetWeightCount1 = 10;
              int targetWeightCount2 = 0;
              bool addExerciseButtonEnabled = false;
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
                        DropdownButton(
                          value: selectedBodyPart,
                          items: excel.keys.map((key) {
                            return DropdownMenuItem(
                              value: key,
                              child: Text(
                                key,
                                style: GoogleFonts.montserrat(),
                                ),
                            );
                          }).toList(),
                          hint: Text(
                            "Select a Body Part",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              color: Colors.white38,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              selectedBodyPart = value;
                              selectedExerciseName = null;
                              addExerciseButtonEnabled = false;
                            });
                          },
                          isExpanded: true,
                          iconSize: 32,
                          iconEnabledColor: Colors.grey.shade500,
                          dropdownColor: Colors.grey.shade800,
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                          ),
                        ),
                        DropdownButton(
                          value: selectedExerciseName,
                          items: selectedBodyPart == null ? null : excel[selectedBodyPart]!.map((key) {
                            return DropdownMenuItem(
                              value: key,
                              child: Text(
                                key,
                                style: GoogleFonts.montserrat(),
                                ),
                            );
                          }).toList(),
                          hint: Text(
                            "Select a Exercise",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              color: Colors.white38,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              selectedExerciseName = value;
                              if (selectedExerciseName != null) {
                                addExerciseButtonEnabled = true;
                              }
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
                        const SizedBox(height: 16),
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
                              value: targetWeightCount2,
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
                              selectedWorkoutPlan!.addExercise(selectedExerciseName!, targetSetCount, targetRepCount, double.parse("$targetWeightCount1.$targetWeightCount2"));
                              saveWorkoutPlanList();
                              Navigator.of(context).pop();
                              update();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: addExerciseButtonEnabled
                                  ? Colors.blue.shade900
                                  : Colors.grey.shade800,
                                borderRadius:
                                    BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Add",
                                style: GoogleFonts.montserrat(
                                  color: addExerciseButtonEnabled
                                    ? Colors.white
                                    : Colors.grey,
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
        },
        backgroundColor: Colors.blue.shade900,
        elevation: 20,
        child: const Icon(Icons.add),
      ),
    );
  }

  void update() {
    saveWorkoutPlanList();
    setState(() {
      //print("Updated");
    });
  }

  Future<List<WorkoutPlan>> getWorkoutPlanList() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    String? workoutPlanStringList =
        sharedPreferences.getString('workoutPlanStringList');
    if (workoutPlanStringList != null) {
      return jsonDecode(workoutPlanStringList)
          .map((i) {
            return WorkoutPlan.fromJson(i);
          })
          .toList()
          .cast<WorkoutPlan>();
    } else {
      return [];
    }
  }

  void saveWorkoutPlanList() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(
        'workoutPlanStringList', jsonEncode(workoutPlanList));
  }

  Future<String> getWelcomeText() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    String? workoutPlanStringList =
        sharedPreferences.getString('workoutPlanStringList');
    if (workoutPlanStringList != null) {
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
