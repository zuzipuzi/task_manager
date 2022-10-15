String? errorText(String? text) {
  if (text!.isEmpty) {
    return "Please enter some text";
  } else {
    return null;
  }
}
