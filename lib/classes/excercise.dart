import 'set.dart';

class Exercise {
  String name;
  String videoLink;
  int targetSet;
  int targetRep;
  int targetWeight;
  List<Set> doneSets;

  Exercise({
    required this.name,
    required this.videoLink,
    required this.targetSet,
    required this.targetRep,
    required this.targetWeight,
    this.doneSets = const [],
  });

  void addSet(int rep, int weight) {
    doneSets.add(Set(date: DateTime.now(), rep: rep, weight: weight));
  }
}