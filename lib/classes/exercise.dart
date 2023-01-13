import 'set.dart';
import 'package:uuid/uuid.dart';

class Exercise {
  String uuid = const Uuid().v1();
  String name;
  String videoLink;
  int targetSet;
  int targetRep;
  int targetWeight;
  List<Set> doneSets=[];

  Exercise({
    required this.name,
    required this.videoLink,
    required this.targetSet,
    required this.targetRep,
    required this.targetWeight,
  });

  void addSet(int rep, int weight) {
    doneSets.add(Set(date: DateTime.now(), rep: rep, weight: weight));
  }
}