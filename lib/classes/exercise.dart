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

  String getLink() {
    return name.toLowerCase().replaceAll(" ", "-");
  }

  void addSet(int rep, double weight) {
    doneSets.add(Set(date: DateTime.now(), rep: rep, weight: weight));
  }
}
