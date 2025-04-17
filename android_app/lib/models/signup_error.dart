class SignupError {
  final String usernameError;
  final String emailError;
  final String passwordError;

  SignupError(
      {this.usernameError = '', this.emailError = '', this.passwordError = ''});

  bool get hasError =>
      usernameError.isNotEmpty ||
      emailError.isNotEmpty ||
      passwordError.isNotEmpty;
}
