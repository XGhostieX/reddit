import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/models/user_model.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserModel>> signInWithGoogle();
  Future<Either<Failure, UserModel>> signInAsGuest();
  Stream<UserModel> getUser(String uid);
  Stream<User?> get authStateChange;
  Future<Either<Failure, void>> signOut();
}
