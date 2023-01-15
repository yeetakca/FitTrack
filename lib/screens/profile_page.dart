import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../classes/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User user = User(name: "Username", height: 0, age: 0, gender: "?");

  TextEditingController usernameTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUser().then((value) => setState(() {
          user = value;
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
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return {"Edit Profile", "Delete Profile Data"}.map((item) {
                return PopupMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: GoogleFonts.montserrat(
                      color: item == "Delete Profile Data"
                          ? Colors.red
                          : Colors.white,
                    ),
                  ),
                );
              }).toList();
            },
            onSelected: (value) {
              switch (value) {
                case "Edit Profile":
                  showDialog(
                      context: context,
                      builder: (context) {
                        bool isProfileSaveButtonEnabled =
                            user.gender != "?" ? true : false;
                        usernameTextEditingController.text =
                            user.gender != "?" ? user.name : "";
                        int inputAge = user.age;
                        int inputHeight = user.height;
                        String inputGender =
                            user.gender == "?" ? "Male" : user.gender;
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              title: Text(
                                "Edit Profile",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              backgroundColor: Colors.grey.shade900,
                              titlePadding: const EdgeInsets.all(24),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                              actionsPadding: const EdgeInsets.all(24),
                              content: Theme(
                                data: ThemeData(
                                  unselectedWidgetColor: Colors.white38,
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: usernameTextEditingController,
                                        onChanged: (value) {
                                          setState(() {
                                            if (value.isEmpty) {
                                              isProfileSaveButtonEnabled = false;
                                            } else {
                                              isProfileSaveButtonEnabled = true;
                                            }
                                          });
                                        },
                                        decoration: InputDecoration(
                                          hintText: "Name and Surname",
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
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      const Divider(
                                        thickness: 1,
                                        color: Colors.white38,
                                      ),
                                      ListTile(
                                        title: Text(
                                          'Male',
                                          style: GoogleFonts.montserrat(
                                            color: Colors.blue,
                                          ),
                                        ),
                                        leading: Radio<String>(
                                          value: "Male",
                                          groupValue: inputGender,
                                          onChanged: (value) {
                                            setState(() {
                                              inputGender = value!;
                                            });
                                          },
                                          activeColor: Colors.blue,
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          'Female',
                                          style: GoogleFonts.montserrat(
                                              color: Colors.pink.shade300),
                                        ),
                                        leading: Radio<String>(
                                          value: "Female",
                                          groupValue: inputGender,
                                          onChanged: (value) {
                                            setState(() {
                                              inputGender = value!;
                                            });
                                          },
                                          activeColor: Colors.pink.shade300,
                                        ),
                                      ),
                                      const Divider(
                                        thickness: 1,
                                        color: Colors.white38,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        "Age",
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.arrow_left,
                                              color: Colors.white38),
                                          NumberPicker(
                                            minValue: 1,
                                            maxValue: 99,
                                            value: inputAge == 0 ? 18 : inputAge,
                                            onChanged: (value) {
                                              setState(() {
                                                inputAge = value;
                                              });
                                            },
                                            selectedTextStyle:
                                                GoogleFonts.montserrat(
                                              color: Colors.blue.shade900,
                                              fontSize: 32,
                                            ),
                                            itemCount: 1,
                                            axis: Axis.horizontal,
                                            itemWidth: 45,
                                          ),
                                          const Icon(Icons.arrow_right,
                                              color: Colors.white38),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        "Height",
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.arrow_left,
                                              color: Colors.white38),
                                          NumberPicker(
                                            minValue: 1,
                                            maxValue: 250,
                                            value: inputHeight == 0
                                                ? 170
                                                : inputHeight,
                                            onChanged: (value) {
                                              setState(() {
                                                inputHeight = value;
                                              });
                                            },
                                            selectedTextStyle:
                                                GoogleFonts.montserrat(
                                              color: Colors.blue.shade900,
                                              fontSize: 32,
                                            ),
                                            itemCount: 1,
                                            axis: Axis.horizontal,
                                            itemWidth: 65,
                                          ),
                                          const Icon(Icons.arrow_right,
                                              color: Colors.white38),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
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
                                        if (isProfileSaveButtonEnabled) {
                                          user.name = usernameTextEditingController.text;
                                          user.gender = inputGender;
                                          user.age = inputAge;
                                          user.height = inputHeight;
                                          saveUser();
                                          update();
                                        }
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: isProfileSaveButtonEnabled
                                              ? Colors.blue.shade900
                                              : Colors.grey.shade800,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          "Save",
                                          style: GoogleFonts.montserrat(
                                            color: isProfileSaveButtonEnabled
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
                case "Delete Profile Data":
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
                          "Are you sure you want to delete the profile data? (This process cannot be undone.)",
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
                                user = User(name: "Username", height: 0, age: 0, gender: "?");;
                                saveUser();
                                update();
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
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade900,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 32),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.blue.shade900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: user.gender == "Male"
                          ? Colors.blue
                          : user.gender == "Female"
                              ? Colors.pink.shade300
                              : Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Icon(
                      Icons.account_circle,
                      color: Colors.white,
                      size: 75,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        "Age",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const SizedBox(
                        height: 10,
                        width: 75,
                        child: Divider(thickness: 1, color: Colors.white38),
                      ),
                      Text(
                        user.age == 0 ? "?" : user.age.toString(),
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        "Height",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const SizedBox(
                        height: 10,
                        width: 75,
                        child: Divider(thickness: 1, color: Colors.white38),
                      ),
                      Text(
                        user.height == 0 ? "?" : user.height.toString(),
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade900,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      Text(
                        "Weight",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const SizedBox(
                        height: 10,
                        width: 75,
                        child: Divider(thickness: 1, color: Colors.white38),
                      ),
                      Text(
                        user.weightHistory.isNotEmpty
                            ? user.weightHistory.last[1].toString()
                            : "?",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Column(
                    children: [
                      GestureDetector(
                        child: const Icon(
                          Icons.history,
                          color: Colors.white,
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    title: Column(
                                      children: [
                                        Text(
                                          "Weight History",
                                          style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "(Press and hold the item you want to delete)",
                                          style: GoogleFonts.montserrat(
                                            color: Colors.white38,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    backgroundColor: Colors.grey.shade900,
                                    titlePadding: const EdgeInsets.all(24),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                                    actionsPadding: const EdgeInsets.all(24),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: user.weightHistory.isEmpty 
                                          ? [Text(
                                            "There is no recorded weight history.",
                                            style: GoogleFonts.montserrat(
                                              color: Colors.white38,
                                            ),
                                            textAlign: TextAlign.center,
                                          )] 
                                          : user.weightHistory.map((e) {
                                          return GestureDetector(
                                            onLongPress: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      "Delete?",
                                                      style: GoogleFonts.montserrat(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    backgroundColor: Colors.grey.shade900,
                                                    titlePadding: const EdgeInsets.all(24),
                                                    contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                                                    actionsPadding: const EdgeInsets.all(8),
                                                    content: Text(
                                                      "Are you sure you want to delete this weight record? (This process cannot be undone.)",
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
                                                              user.weightHistory.removeWhere((element) => element == e);
                                                              saveUser();
                                                              update();
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
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                                              margin: user.weightHistory.last != e ? const EdgeInsets.only(bottom: 8) : const EdgeInsets.only(),
                                              decoration: BoxDecoration(
                                                color: Colors.black45,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Text(
                                                    DateFormat('dd - MM - yyyy').format(DateTime.fromMillisecondsSinceEpoch(e[0])),
                                                    style: GoogleFonts.montserrat(
                                                      color: Colors.blue.shade900,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        e[1].toString(),
                                                        style: GoogleFonts.montserrat(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        "KG",
                                                        style: GoogleFonts.montserrat(
                                                          color: Colors.white38,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
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
                                                padding: const EdgeInsets
                                                        .symmetric(
                                                    horizontal: 16,
                                                    vertical: 8),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue.shade900,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8),
                                                ),
                                                child: Text(
                                                  "OK",
                                                  style:
                                                      GoogleFonts.montserrat(
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
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                int val1 = user.weightHistory.isNotEmpty
                                    ? int.parse(user.weightHistory.last[1]
                                        .toString()
                                        .split(".")[0])
                                    : 60;
                                int val2 = user.weightHistory.isNotEmpty
                                    ? int.parse(user.weightHistory.last[1]
                                        .toString()
                                        .split(".")[1])
                                    : 0;
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: Text(
                                        "Edit Weight",
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
                                          const Icon(Icons.arrow_drop_up,
                                              color: Colors.white38),
                                          const Divider(
                                            thickness: 1,
                                            color: Colors.white38,
                                            indent: 32,
                                            endIndent: 32,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              NumberPicker(
                                                minValue: 1,
                                                maxValue: 300,
                                                value: val1,
                                                onChanged: (value) {
                                                  setState(() {
                                                    val1 = value;
                                                  });
                                                },
                                                selectedTextStyle:
                                                    GoogleFonts.montserrat(
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
                                                infiniteLoop: true,
                                                zeroPad: true,
                                                value: val2,
                                                onChanged: (value) {
                                                  setState(() {
                                                    val2 = value;
                                                  });
                                                },
                                                selectedTextStyle:
                                                    GoogleFonts.montserrat(
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
                                            indent: 32,
                                            endIndent: 32,
                                          ),
                                          const Icon(Icons.arrow_drop_down,
                                              color: Colors.white38),
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
                                                padding: const EdgeInsets
                                                        .symmetric(
                                                    horizontal: 16,
                                                    vertical: 8),
                                                decoration: BoxDecoration(
                                                  color: Colors.red.shade900,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8),
                                                ),
                                                child: Text(
                                                  "Cancel",
                                                  style:
                                                      GoogleFonts.montserrat(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                user.updateWeight(
                                                    double.parse(
                                                        "$val1.$val2"));
                                                Navigator.of(context).pop();
                                                saveUser();
                                                update();
                                              },
                                              child: Container(
                                                padding: const EdgeInsets
                                                        .symmetric(
                                                    horizontal: 16,
                                                    vertical: 8),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue.shade900,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8),
                                                ),
                                                child: Text(
                                                  "Save",
                                                  style:
                                                      GoogleFonts.montserrat(
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
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          // OPEN GALLERY PAGE
        }),
        backgroundColor: Colors.blue.shade900,
        child: const Icon(Icons.photo),
      ),
    );
  }

  Future<User> getUser() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    String? userString = sharedPreferences.getString('user');
    if (userString != null) {
      return User.fromJson(jsonDecode(userString));
    } else {
      return User(name: "Username", height: 0, age: 0, gender: "?");
    }
  }

  void saveUser() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('user', jsonEncode(user));
  }

  void update() {
    setState(() {
      //print("Updated");
    });
  }
}
