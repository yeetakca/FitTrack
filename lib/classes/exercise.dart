import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import 'set.dart';

class Exercise {
  String uuid = const Uuid().v1();
  String name;
  int targetSet;
  int targetRep;
  double targetWeight;
  List<Set> doneSets = [];

  Exercise({
    required this.name,
    required this.targetSet,
    required this.targetRep,
    required this.targetWeight,
  });

  Exercise.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        name = json['name'],
        targetSet = json['targetSet'],
        targetRep = json['targetRep'],
        targetWeight = json['targetWeight'],
        doneSets = json['doneSets'].isEmpty
            ? []
            : json['doneSets']
                .map((element) {
                  return Set.fromJson(element);
                })
                .toList()
                .cast<Set>();

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'targetSet': targetSet,
      'targetRep': targetRep,
      'targetWeight': targetWeight,
      'doneSets': doneSets,
    };
  }

  Future<String> getLink() async {
    Map<String, dynamic> exercises = {};
    String result = "";
    await readJson().then((value) {
      exercises = value;
    });
    exercises.forEach((key, value) {
      value.forEach((key2) {
        if (key2["Exercise"] == name) {
          String link = '${key2["Equipment"]}/male/$key/';
          result = link + name.toLowerCase().replaceAll(" ", "-");
        }
      });
    });
    return result;
  }

  String getvideoLink() {
    return name.toLowerCase().replaceAll(" ", "-");
  }

  void addSet(int rep, double weight) {
    doneSets.add(Set(date: DateTime.now(), rep: rep, weight: weight));
  }

  Future<Map<String, dynamic>> readJson() async {
    String response = await rootBundle.loadString('assets/exercises.json');
    Map<String, dynamic> data = await json.decode(response);
    return data;
  }
}
