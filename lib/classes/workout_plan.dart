import 'exercise.dart';
import 'package:uuid/uuid.dart';

class WorkoutPlan {
  String uuid = const Uuid().v1();
  String name;
  List<Exercise> exerciseList = [];

  WorkoutPlan({
    required this.name,
  });

  void addExercise(
      String name, int targetSet, int targetRep, double targetWeight) {
    exerciseList.add(Exercise(
        name: name,
        targetSet: targetSet,
        targetRep: targetRep,
        targetWeight: targetWeight));
  }
}
