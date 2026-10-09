// Form validation
class Validators {
  // Task Validator
  static String? validateTaskTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a task title';
    }

    return null;
  }

}
