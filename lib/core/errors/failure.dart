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
    } else if (e.description!.contains('NETWORK') ||
        e.description!.contains('network')) {
      return AuthFailure('Network error occurred');
    } else if (e.description!.contains('INVALID') ||
        e.description!.contains('invalid')) {
      return AuthFailure('Invalid account selected');
    } else {
      return AuthFailure('Google Sign-In failed: ${e.description!}');
    }
  }
}

class FirebaseFailure extends Failure {
  FirebaseFailure(super.errMsg);

  factory FirebaseFailure.handleFirebaseException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return FirebaseFailure(
          'You don\'t have permission to access this data.',
        );

      case 'not-found':
        return FirebaseFailure('The requested document was not found.');

      case 'already-exists':
        return FirebaseFailure('A document with this ID already exists.');

      case 'resource-exhausted':
        return FirebaseFailure('Too many requests. Please try again later.');

      case 'failed-precondition':
        return FirebaseFailure(
          'Operation was rejected. Please check your data.',
        );

      case 'aborted':
        return FirebaseFailure('The operation was aborted.');

      case 'out-of-range':
        return FirebaseFailure(
          'The operation was attempted past the valid range.',
        );

      case 'unimplemented':
        return FirebaseFailure('This operation is not implemented.');

      case 'internal':
        return FirebaseFailure('Internal server error. Please try again.');

      case 'unavailable':
        return FirebaseFailure(
          'Service is temporarily unavailable. Please try again.',
        );

      case 'data-loss':
        return FirebaseFailure('Unrecoverable data loss or corruption.');

      case 'deadline-exceeded':
        return FirebaseFailure('The operation timed out. Please try again.');

      case 'cancelled':
        return FirebaseFailure('The operation was cancelled.');

      default:
        return FirebaseFailure('A database error occurred: ${e.message}');
    }
  }
}
