import 'exercise.dart';
import 'package:uuid/uuid.dart';

class WorkoutPlan {
  String uuid = const Uuid().v1();
  String name;
  List<Exercise> exerciseList = [];

  WorkoutPlan({
    required this.name,
  });

  WorkoutPlan.fromJson(Map<String, dynamic> json)
    : uuid = json['uuid'],
    name = json['name'],
    exerciseList = json['exerciseList'].map((element) {
      return Exercise.fromJson(element);
    }).toList().cast<Exercise>();

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'exerciseList': exerciseList,
    };
  }

  void addExercise(
      String name, int targetSet, int targetRep, double targetWeight) {
    exerciseList.add(Exercise(
        name: name,
        targetSet: targetSet,
        targetRep: targetRep,
        targetWeight: targetWeight));
  }
}
