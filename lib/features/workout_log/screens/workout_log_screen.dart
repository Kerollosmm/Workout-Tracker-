import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/workout.dart';
import '../../../core/models/workout_set.dart';
import '../../../core/providers/exercise_provider.dart';
import '../../../core/providers/workout_provider.dart';
import '../widgets/exercise_selector.dart';
import '../widgets/workout_form.dart';
import '../widgets/set_input_card.dart';

class WorkoutLogScreen extends StatefulWidget {
  @override
  _WorkoutLogScreenState createState() => _WorkoutLogScreenState();
}

class _WorkoutLogScreenState extends State<WorkoutLogScreen> {
  final uuid = Uuid();
  final List<WorkoutExercise> selectedExercises = [];
  DateTime workoutDate = DateTime.now();
  String? notes;
  
  void _addExercise(BuildContext context) async {
    final exerciseProvider = Provider.of<ExerciseProvider>(context, listen: false);
    
    // Navigate to exercise selection screen
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ExerciseSelector(
        exercises: exerciseProvider.exercises,
      ),
    );
    
    if (result != null) {
      setState(() {
        selectedExercises.add(
          WorkoutExercise(
            exerciseId: result.id,
            exerciseName: result.name,
            muscleGroup: result.muscleGroup,
            sets: [], // Empty sets to be filled
          ),
        );
      });
    }
  }
  void _removeSet(int exerciseIndex, int setIndex) {
  setState(() {
    selectedExercises[exerciseIndex].sets.removeAt(setIndex);
  });
}

void _saveWorkout() async {
  if (selectedExercises.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please add at least one exercise')),
    );
    return;
  }

  // Validate that all sets have values
  bool hasEmptySets = false;
  for (final exercise in selectedExercises) {
    if (exercise.sets.isEmpty) {
      hasEmptySets = true;
      break;
    }
    
    for (final set in exercise.sets) {
      if (set.weight <= 0 || set.reps <= 0) {
        hasEmptySets = true;
        break;
      }
    }
    
    if (hasEmptySets) break;
  }
  
  if (hasEmptySets) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please complete all set information')),
    );
    return;
  }
  
  // Create workout object
  final workout = Workout(
    id: uuid.v4(),
    date: workoutDate,
    exercises: selectedExercises,
    notes: notes,
  );
  
  // Save to Hive via provider
  final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
  await workoutProvider.addWorkout(workout);
  
  // Show success and navigate back
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Workout saved successfully')),
  );
  Navigator.pop(context);
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Log Workout'),
      actions: [
        IconButton(
          icon: Icon(Icons.save),
          onPressed: _saveWorkout,
        ),
      ],
    ),
    body: Column(
      children: [
        // Date selector
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.calendar_today),
              SizedBox(width: 8),
              Text(
                'Date: ${DateFormat('MMM dd, yyyy').format(workoutDate)}',
                style: TextStyle(fontSize: 16),
              ),
              Spacer(),
              TextButton(
                child: Text('Change'),
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: workoutDate,
                    firstDate: DateTime.now().subtract(Duration(days: 30)),
                    lastDate: DateTime.now(),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      workoutDate = selectedDate;
                    });
                  }
                },
              ),
            ],
          ),
        ),
        
        Divider(),
        
        // Exercises and sets
        Expanded(
          child: selectedExercises.isEmpty
              ? Center(
                  child: Text(
                    'Tap "Add Exercise" to begin',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: selectedExercises.length,
                  itemBuilder: (context, exerciseIndex) {
                    final exercise = selectedExercises[exerciseIndex];
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Exercise header
                            Row(
                              children: [
                                Icon(Icons.fitness_center),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    exercise.exerciseName,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  exercise.muscleGroup,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _removeExercise(exerciseIndex),
                                ),
                              ],
                            ),
                            
                            Divider(),
                            
                            // Set headers
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  SizedBox(width: 40),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Weight',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Reps',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(width: 48),
                                ],
                              ),
                            ),
                            
                            // Sets
                            ...List.generate(
                              exercise.sets.length,
                              (setIndex) => SetInputCard(
                                setNumber: setIndex + 1,
                                weight: exercise.sets[setIndex].weight,
                                reps: exercise.sets[setIndex].reps,
                                onWeightChanged: (value) {
                                  _updateSet(
                                    exerciseIndex,
                                    setIndex,
                                    value,
                                    exercise.sets[setIndex].reps,
                                  );
                                },
                                onRepsChanged: (value) {
                                  _updateSet(
                                    exerciseIndex,
                                    setIndex,
                                    exercise.sets[setIndex].weight,
                                    value,
                                  );
                                },
                                onDelete: () => _removeSet(exerciseIndex, setIndex),
                              ),
                            ),
                            
                            // Add set button
                            Center(
                              child: TextButton.icon(
                                icon: Icon(Icons.add),
                                label: Text('Add Set'),
                                onPressed: () => _addSet(exerciseIndex),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        
        // Notes field
        Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Notes (optional)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.note),
            ),
            maxLines: 2,
            onChanged: (value) {
              setState(() {
                notes = value;
              });
            },
          ),
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => _addExercise(context),
      tooltip: 'Add Exercise',
    ),
  );
}

}