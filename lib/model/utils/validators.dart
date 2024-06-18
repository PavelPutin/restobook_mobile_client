String? onlyEnglishDigitsAndSomeSpecial(String value) {
  var re = RegExp(r"^[a-zA-Z\d$@!%]+$");
  if (!re.hasMatch(value)) {
    return "Поле может содержать только английские буквы, цифры, \$, @, !, %";
  }
  return null;
}