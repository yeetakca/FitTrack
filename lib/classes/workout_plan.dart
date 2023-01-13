import 'exercise.dart';
import 'package:uuid/uuid.dart';

class WorkoutPlan {
  String uuid = const Uuid().v1();
  String name;
  List<Exercise> exerciseList = [];

  WorkoutPlan({
    required this.name,
  });

  void addExercise(String name, String videoLink, int targetSet, int targetRep, int targetWeight) {
    exerciseList.add(Exercise(name: name, videoLink: videoLink, targetSet: targetSet, targetRep: targetRep, targetWeight: targetWeight));
  }
}