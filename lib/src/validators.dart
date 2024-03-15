String? requireValue(String? value) {
  if (value == null || value.isEmpty) {
    return "Required field";
  }
  return null;
}

String? emailValidator(String? value) {
  if (value != null &&
      value.isNotEmpty &&
      !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(value)) {
    return "Please enter a valid email";
  }
  return null;
}

String? phoneValidator(String? value) {
  if (value != null &&
      value.isNotEmpty &&
      !RegExp(r"^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]\d{3}[\s.-]\d{4}$")
          .hasMatch(value)) {
    return "Please enter a valid phone number";
  }
  return null;
}
