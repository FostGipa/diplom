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

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Поле Номер телефона не должно быть пустым';
    }

    final phoneRegExp = RegExp(r'^\+7 \(\d{3}\) \d{3}-\d{2}-\d{2}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Некорректный номер телефона. Формат: +7(987)111-11-11';
    }

    return null;
  }

}