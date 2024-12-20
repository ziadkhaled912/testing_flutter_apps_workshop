extension Validators on String {
  bool isValidEmail() {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }

  bool isValidPassword() {
    return length >= 6;
  }

  bool isValidName() {
    return length >= 3;
  }
}
