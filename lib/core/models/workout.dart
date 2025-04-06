import 'package:hive/hive.dart';
import 'exercise.dart';
import 'workout_set.dart';
part 'workout.g.dart';

@HiveType(typeId: 2)
class Workout extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  DateTime date;
  
  @HiveField(2)
  List<WorkoutExercise> exercises;
  
  @HiveField(3)
  int duration; // in seconds
  
  @HiveField(4)
  String? notes;
  
  Workout({
    required this.id,
    required this.date,
    required this.exercises,
    this.duration = 0,
    this.notes,
  });
  
  // Helper methods to calculate workout stats
  double get totalWeightLifted {
    double total = 0;
    for (final exercise in exercises) {
      for (final set in exercise.sets) {
        total += set.weight * set.reps;
      }
    }
    return total;
  }
  
  int get totalSets {
    int total = 0;
    for (final exercise in exercises) {
      total += exercise.sets.length;
    }
    return total;
  }
}

@HiveType(typeId: 3)
class WorkoutExercise {
  @HiveField(0)
  String exerciseId;
  
  @HiveField(1)
  String exerciseName;
  
  @HiveField(2)
  String muscleGroup;
  
  @HiveField(3)
  List<WorkoutSet> sets;
  
  WorkoutExercise({
    required this.exerciseId,
    required this.exerciseName,
    required this.muscleGroup,
    required this.sets,
  });
}
