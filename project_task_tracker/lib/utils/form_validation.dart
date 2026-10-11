// Form validation
class Validators {
  static String? signInEmailValidation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? sigInPasswordValidation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a correct password';
    }
    return null;
  }

  static String? validateTaskTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a task title';
    }

    return null;
  }

  static String? validateAddMemberName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the member name';
    }
    return null;
  }

  static String? validateAddMemberRole(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the member role';
    }
    return null;
  }
}
