

final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

String? emailValidation(String? value) {
  if (value!.isEmpty) {
    return "Email shouldn't be empty";
  } else if (!value.contains(emailRegex)) {
    return "Email isn't in the correct form";
  }

  return null;
}

String? passwordValidation(String? value) {
  if (value!.isEmpty) {
    return "Password shouldn't be empty";
  } else if (value.length < 7) {
    return "Password should be greater than 7 characters";
  } else if (!value.contains(RegExp('[A-Za-z]')) ||
      !value.contains(RegExp('[0-9]'))) {
    return "Password should contain alphabets & numbers";
  }

  return null;
}


String? phoneNumberValidation(value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Only numbers are allowed';
    }
    if (value.length != 11) {
      return 'Phone number must be exactly 11 digits';
    }
    return null;
  }


String? nameValidation(String? value) {
  if (value!.isEmpty) {
    return "Name shouldn't be empty";
  } else if (value.length <=4) {
    return "Name should be greater or equal to 4 characters";
  } else if (
      value.contains(RegExp('[0-9]'))) {
    return "Name shouldn't contains numbers";
  }

  return null;
}


String? notNullValidation(String? value) {
  if (value!.isEmpty) {
    return "Field shouldn't be empty";
  }

  return null;
}
