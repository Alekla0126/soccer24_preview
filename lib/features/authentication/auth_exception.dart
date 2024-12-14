import '../../constants/strings.dart';

class AuthException implements Exception {
  final String message;

  const AuthException([this.message = Strings.unknownError]);

  factory AuthException.fromCode(String code) {
    switch (code.toLowerCase()) {
      case 'invalid_login_credentials':
        return const AuthException(
          Strings.emailOrPassword,
        );
      case 'invalid-email':
        return const AuthException(
          Strings.invalidEmailError,
        );
      case 'user-disabled':
        return const AuthException(
          Strings.userDisabled,
        );
      case 'user-not-found':
        return const AuthException(
          Strings.userNotFound,
        );
      case 'wrong-password':
        return const AuthException(
          Strings.wrongPassword,
        );
      case 'account-exists-with-different-credential':
        return const AuthException(
          Strings.accountExistsWithDifferentCredential,
        );
      case 'invalid-credential':
        return const AuthException(
          Strings.invalidCredential,
        );
      case 'operation-not-allowed':
        return const AuthException(
          Strings.operationNotAllowed,
        );
      case 'invalid-verification-code':
        return const AuthException(
          Strings.invalidVerificationCode,
        );
      case 'invalid-verification-id':
        return const AuthException(
          Strings.invalidVerificationId,
        );
      case 'email-already-in-use':
        return const AuthException(
          Strings.emailAlreadyInUse,
        );
      case 'weak-password':
        return const AuthException(
          Strings.weekPassword,
        );
      case 'too-many-requests':
        return const AuthException(
          Strings.tooManyRequests,
        );
      case 'Failed to sign in with Apple. Please try again.':
        return const AuthException(
          Strings.appleLoginFailure,
        );
      default:
        return const AuthException(
          Strings.unknownError,
        );
    }
  }

  factory AuthException.signInFailure() {
    return const AuthException(Strings.loginFailure);
  }

  factory AuthException.signInWithGoogleFailure() {
    return const AuthException(Strings.googleLoginFailure);
  }

  factory AuthException.signInAnonymouslyFailure() {
    return const AuthException(Strings.loginAnonymouslyFailure);
  }

  factory AuthException.signUpFailure() {
    return const AuthException(Strings.googleLoginFailure);
  }

  factory AuthException.resetPasswordFailure() {
    return const AuthException(Strings.emailNotSent);
  }

  factory AuthException.logoutFailure() {
    return const AuthException(Strings.logoutFailure);
  }

  factory AuthException.deleteAccountFailure() {
    return const AuthException(Strings.deleteAccountFailure);
  }

  factory AuthException.signInWithAppleFailure() {
    return const AuthException(Strings.appleLoginFailure);
  }
}
