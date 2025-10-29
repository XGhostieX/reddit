import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/models/post_model.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/utils/service_locator.dart';
import 'profile_repo.dart';

class ProfileRepoImpl implements ProfileRepo {
  final FirebaseFirestore firebaseFirestore;

  ProfileRepoImpl(this.firebaseFirestore);

  CollectionReference get _users => firebaseFirestore.collection('users');
  CollectionReference get _posts => firebaseFirestore.collection('posts');

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

  @override
  Stream<List<PostModel>> getUserPosts(String uid) {
    return _posts
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) =>
              event.docs.map((e) => PostModel.fromMap(e.data() as Map<String, dynamic>)).toList(),
        );
  }

  @override
  Future<Either<Failure, void>> updateKarma(UserModel user) async {
    try {
      return right(_users.doc(user.uid).update({'karma': user.karma}));
    } on FirebaseException catch (e) {
      return left(FirebaseFailure.handleFirebaseException(e));
    } catch (e) {
      return left(FirebaseFailure(e.toString()));
    }
  }
}

final profileRepoProvider = Provider((ref) => ProfileRepoImpl(ref.read(firebaseFirestoreProvider)));
