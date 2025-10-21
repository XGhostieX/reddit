import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/utils/service_locator.dart';
import 'profile_repo.dart';

class ProfileRepoImpl implements ProfileRepo {
  final FirebaseFirestore firebaseFirestore;

  ProfileRepoImpl(this.firebaseFirestore);

  CollectionReference get _users => firebaseFirestore.collection('users');

  @override
  Future<Either<Failure, void>> editProfile(UserModel user) async {
    try {
      return right(_users.doc(user.uid).update(user.toMap()));
    } on FirebaseException catch (e) {
      return left(FirebaseFailure.handleFirebaseException(e));
    } catch (e) {
      return left(FirebaseFailure(e.toString()));
    }
  }
}

final profileRepoProvider = Provider((ref) => ProfileRepoImpl(ref.read(firebaseFirestoreProvider)));
