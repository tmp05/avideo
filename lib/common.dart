class Common {
  bool validateEmail(String value) {
    const String pattern = r'^[-0-9A-z_.]{1,20}@([-0-9A-z_.]+\.){1,20}([0-9A-z]){2,5}$';
    final RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
       return false;
    }
    return true;
  }
}