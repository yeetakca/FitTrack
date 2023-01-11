import 'excercise.dart';

class WorkoutPlan {
  String name;
  List<Exercise> exerciseList;

  WorkoutPlan({
    required this.name,
    this.exerciseList = const [],
  });

  void addExercise(String name, String videoLink, int targetSet, int targetRep, int targetWeight) {
    exerciseList.add(Exercise(name: name, videoLink: videoLink, targetSet: targetSet, targetRep: targetRep, targetWeight: targetWeight));
  }
}