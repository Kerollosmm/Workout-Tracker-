import 'package:hive/hive.dart';
part 'workout_set.g.dart';

@HiveType(typeId: 1)
class WorkoutSet extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  double weight;
  
  @HiveField(2)
  int reps;
  
  @HiveField(3)
  DateTime timestamp;
  
  // Optional
  @HiveField(4)
  bool isCompleted;
  
  @HiveField(5)
  String? notes;
  
  WorkoutSet({
    required this.id,
    required this.weight,
    required this.reps,
    required this.timestamp,
    this.isCompleted = true,
    this.notes,
  });
}
