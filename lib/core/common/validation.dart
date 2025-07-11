sealed class Validation{

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your Name!";
    }
    if (value.length <= 2) {
      return "Please enter valid Name!";
    }
    RegExp nameRegExp = RegExp(r'^[a-zA-ZğüşöçĞÜŞÖÇ\s]+$');
    if (!nameRegExp.hasMatch(value)) {
      return "Name should contain only letters or space!";
    }
    return null;
  }

  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your Address!";
    }
    if (value.trim().length <= 2) {
      return "Please enter a valid Address!";
    }
    RegExp addressRegExp = RegExp(r'^[a-zA-ZğüşöçĞÜŞÖÇ0-9\s,.\-]+$');

    if (!addressRegExp.hasMatch(value.trim())) {
      return "Address contains invalid characters!";
    }

    return null;
  }

  static String? validateInn(String? value){
    if(value==null || value.isEmpty){
      return "Please enter your Inn!";
    }
    RegExp innRegExp = RegExp(r'^[0-9]+$');
    if (!innRegExp.hasMatch(value)) {
      return "Inn should contain only numbers!";
    }
    if (value.length < 5) {
      return "Inn should be at least 5 digits!";
    }
    return null;
  }

  static String? validateService(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter Service name!";
    }

    RegExp nameRegExp = RegExp(r'^[a-zA-ZğüşöçĞÜŞÖÇ\s]+$');
    if (!nameRegExp.hasMatch(value.trim())) {
      return "Service should contain only letters or space!";
    }

    return null;
  }

  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your Amount!";
    }
    RegExp innRegExp = RegExp(r'^[0-9]+$');
    if (!innRegExp.hasMatch(value)) {
      return "Amount should contain only numbers!";
    }
    return null;
  }

}