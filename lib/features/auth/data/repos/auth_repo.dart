import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/models/user_model.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserModel>> signInWithGoogle();
  Stream<UserModel> getUser(String uid);
  Stream<User?> get authStateChange;
}
