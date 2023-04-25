extension Validation on String {
  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this);
  }

  bool get isValidName {
    final nameRegExp = RegExp(r"^[a-zA-Z0-9.,]+");
    return nameRegExp.hasMatch(this);
  }

  bool get isValidPassword {
    final passwordRegExp = RegExp(r"^[a-zA-Z0-9.,]{3,}$");
    return passwordRegExp.hasMatch(this);
  }

  bool get isValidPrice {
    final phoneRegExp = RegExp(r"^[0-9]+.[0-9]+$");
    return phoneRegExp.hasMatch(this);
  }
}
