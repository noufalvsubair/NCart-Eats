class ValidationUtils {
  static bool validatePhoneNumber(String phoneNumber) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);

    return regExp.hasMatch(phoneNumber);
  }
}
