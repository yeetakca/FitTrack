import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../classes/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

User defaultUser = User(name: "Username", height: 0, age: 0, gender: "?");

class _ProfilePageState extends State<ProfilePage> {
  User user = defaultUser;

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
                      color: item == "Delete Profile Data" ? Colors.red : Colors.white,
                    ),
                  ),
                );
              }).toList();
            },
            onSelected: (value) {
              switch (value) {
                case "Edit Profile":
                  // EDIT PROFILE DATA
                  break;
                case "Delete Profile Data":
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
                                user = defaultUser;
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
                      color: user.gender == "Male" ? Colors.blue : user.gender == "Female" ? Colors.pink.shade300 : Colors.grey.shade700,
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
                          // WEIGHT HISTORY
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
                                ? int.parse(user.weightHistory.last[1].toString().split(".")[0])
                                : 60;
                              int val2 = user.weightHistory.isNotEmpty
                                ? int.parse(user.weightHistory.last[1].toString().split(".")[1])
                                : 0;
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    title: Padding(
                                      padding: const EdgeInsets.only(bottom: 16),
                                      child: Text(
                                        "Edit Weight",
                                        style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    backgroundColor: Colors.grey.shade900,
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.arrow_drop_up, color: Colors.white38),
                                        const Divider(
                                          thickness: 1,
                                          color: Colors.white38,
                                          indent: 32,
                                          endIndent: 32,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
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
                                              infiniteLoop: true,
                                              zeroPad: true,
                                              value: val2,
                                              onChanged: (value) {
                                                setState(() {
                                                  val2 = value;
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
                                          indent: 32,
                                          endIndent: 32,
                                        ),
                                        const Icon(Icons.arrow_drop_down, color: Colors.white38),
                                      ],
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
                                                user.updateWeight(double.parse("$val1.$val2"));
                                                Navigator.of(context).pop();
                                                saveUser();
                                                update();
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
      return defaultUser;
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