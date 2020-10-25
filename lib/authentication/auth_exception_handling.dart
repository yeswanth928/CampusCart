enum AuthResultStatus {
  successful,
  emailAlreadyExists,
  emailNotVerified,
  emailNotSent,
  wrongPassword,
  weakPassword,
  invalidEmail,
  userNotFound,
  userDisabled,
  operationNotAllowed,
  tooManyRequests,
  accountWithDifferentCredential,
  undefined,
}

class AuthExceptionHandler {
  static handleException(e) {
    var status;
    switch (e.code) {
      case "invalid-email":
        status = AuthResultStatus.invalidEmail;
        break;
      case "wrong-password":
        status = AuthResultStatus.wrongPassword;
        break;
      case "user-not-found":
        status = AuthResultStatus.userNotFound;
        break;
      case "weak-password":
        status = AuthResultStatus.weakPassword;
        break;
      case "user-disabled":
        status = AuthResultStatus.userDisabled;
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        status = AuthResultStatus.tooManyRequests;
        break;
      case "account-exists-with-different-credential":
        status = AuthResultStatus.accountWithDifferentCredential;
        break;
      case "operation-not-allowed":
        status = AuthResultStatus.operationNotAllowed;
        break;
      case "email-already-in-use":
        status = AuthResultStatus.emailAlreadyExists;
        break;
      default:
        status = AuthResultStatus.undefined;
    }
    return status;
  }

  // Accepts AuthExceptionHandler.errorType

  static generateExceptionMessage(exceptionCode) {
    String errorMessage;
    switch (exceptionCode) {
      case AuthResultStatus.invalidEmail:
        errorMessage = "Please enter a valid Email id.";
        break;
      case AuthResultStatus.emailNotVerified:
        errorMessage = "Please verify email before loging in.";
        break;
      case AuthResultStatus.emailNotSent:
        errorMessage =
            "There seems to be some problem. \n The email was not sent. Please try again later.";
        break;
      case AuthResultStatus.wrongPassword:
        errorMessage = "Invalid Password";
        break;
      case AuthResultStatus.weakPassword:
        errorMessage = "Please Enter a Strong password.";
        break;
      case AuthResultStatus.userNotFound:
        errorMessage = "The entered Email is not registered to use this app";
        break;
      case AuthResultStatus.userDisabled:
        errorMessage = "User with this email has been disabled.";
        break;
      case AuthResultStatus.tooManyRequests:
        errorMessage = "Too many requests. Try again later.";
        break;
      case AuthResultStatus.operationNotAllowed:
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      case AuthResultStatus.emailAlreadyExists:
        errorMessage =
            "The email has already been registered. Please login or reset your password.";
        break;
      case AuthResultStatus.accountWithDifferentCredential:
        errorMessage = "The ACcount exists with different credential";
        break;
      default:
        errorMessage = "Something unexpected has happened. Please try again.";
    }

    return errorMessage;
  }
}
