import 'package:google_sign_in/google_sign_in.dart';

abstract class Failure {
  final String errMsg;

  Failure(this.errMsg);
}

class GoogleSignInFailure extends Failure {
  GoogleSignInFailure(super.errMsg);

  factory GoogleSignInFailure.handleGoogleSignInException(
    GoogleSignInException e,
  ) {
    if (e.description!.contains('CANCELLED') ||
        e.description!.contains('cancelled')) {
      return GoogleSignInFailure('Sign in cancelled by user');
    } else if (e.description!.contains('NETWORK_ERROR') ||
        e.description!.contains('network')) {
      return GoogleSignInFailure('Network error occurred');
    } else if (e.description!.contains('INVALID_ACCOUNT')) {
      return GoogleSignInFailure('Invalid account selected');
    } else {
      return GoogleSignInFailure('Google Sign-In failed: ${e.description!}');
    }
  }
}
