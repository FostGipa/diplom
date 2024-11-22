class TValidator {

  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return 'Поле $fieldName не должно быть пустым';
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Поле Почта не должно быть пустым';
    }

    final emailRegExp = RegExp(r'^[\w.-]+@[\w.-]+\.[a-zA-Z]{2,}$');

    if  (!emailRegExp.hasMatch(value)) {
      return 'Некорректная почта';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Поле Пароль не должно быть пустым';
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
      return 'Поле Номер телефона не должно быть пустым';
    }
    
    final phoneRegExp = RegExp(r'^\d{10}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Некорректный номер телефона.';
    }

    return null;
  }
}