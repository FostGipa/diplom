class TValidator {
  static String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email is required.';
    }

    final emailRegExp = RegExp(r'^[\w.-]+@[\w.-]+\.[a-zA-Z]{2,}$');

    if  (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address.';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }

    if (value.length < 6) {
      return 'Пароль должен содержать не менее 6 символов';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Пароль должен содержать хотя бы одну цифру';
    }

    return null;
  }
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Требуется номер телефона.';
    }
    
    final phoneRegExp = RegExp(r'^\d{10}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Некорректный номер телефона.';
    }

    return null;
  }
}