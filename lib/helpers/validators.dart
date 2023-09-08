bool emailValid(String email) {
  RegExp reg = RegExp(r"^[^@]+@[^@]+\.[^@]+$");
  return reg.hasMatch(email);
}
