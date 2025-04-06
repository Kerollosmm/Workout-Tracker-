class Validators {
  // Validate exercise name
  static String? validateExerciseName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Exercise name is required';
    }
    return null;
  }
  
  // Validate weight
  static String? validateWeight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Weight is required';
    }
    
    final weight = double.tryParse(value);
    if (weight == null) {
      return 'Please enter a valid number';
    }
    
    if (weight <= 0) {
      return 'Weight must be greater than 0';
    }
    
    return null;
  }
  
  // Validate reps
  static String? validateReps(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Reps are required';
    }
    
    final reps = int.tryParse(value);
    if (reps == null) {
      return 'Please enter a valid number';
    }
    
    if (reps <= 0) {
      return 'Reps must be greater than 0';
    }
    
    return null;
  }
}
