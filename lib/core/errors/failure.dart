import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class Failure {
  final String errMsg;

  Failure(this.errMsg);
}

class AuthFailure extends Failure {
  AuthFailure(super.errMsg);

  factory AuthFailure.handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'account-exists-with-different-credential':
        return AuthFailure(
          'An account already exists with the same email address',
        );
      case 'invalid-credential':
        return AuthFailure('The credential is invalid or expired');
      case 'operation-not-allowed':
        return AuthFailure('Google Sign-In is not enabled');
      case 'user-disabled':
        return AuthFailure('This user has been disabled');
      case 'user-not-found':
        return AuthFailure('User not found');
      case 'wrong-password':
        return AuthFailure('Wrong password');
      case 'invalid-verification-code':
        return AuthFailure('Invalid verification code');
      case 'invalid-verification-id':
        return AuthFailure('Invalid verification ID');
      case 'network-request-failed':
        return AuthFailure('Network error occurred');
      default:
        return AuthFailure('Authentication failed: ${e.message}');
    }
  }

  factory AuthFailure.handleGoogleSignInException(GoogleSignInException e) {
    if (e.description!.contains('CANCELLED') ||
        e.description!.contains('cancelled')) {
      return AuthFailure('Sign in cancelled by user');
    } else if (e.description!.contains('NETWORK_ERROR') ||
        e.description!.contains('network')) {
      return AuthFailure('Network error occurred');
    } else if (e.description!.contains('INVALID_ACCOUNT')) {
      return AuthFailure('Invalid account selected');
    } else {
      return AuthFailure('Google Sign-In failed: ${e.description!}');
    }
  }
}
