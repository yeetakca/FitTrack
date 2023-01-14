import 'dart:convert';

import 'set.dart';
import 'package:uuid/uuid.dart';

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
    doneSets = json['doneSets'].isEmpty ? [] : json['doneSets'].map((element) {
      return Set.fromJson(element);
    }).toList().cast<Set>();

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

  String getLink() {
    return name.toLowerCase().replaceAll(" ", "-");
  }

  void addSet(int rep, double weight) {
    doneSets.add(Set(date: DateTime.now(), rep: rep, weight: weight));
  }
}
