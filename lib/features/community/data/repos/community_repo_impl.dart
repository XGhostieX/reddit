import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/models/community_model.dart';
import '../../../../core/utils/service_locator.dart';
import 'community_repo.dart';

class CommunityRepoImpl implements CommunityRepo {
  final FirebaseFirestore firebaseFirestore;

  CommunityRepoImpl(this.firebaseFirestore);

  CollectionReference get _communities =>
      firebaseFirestore.collection('communities');

  @override
  Future<Either<Failure, void>> createCommunity(
    CommunityModel community,
  ) async {
    try {
      var communities = await _communities.doc(community.name).get();
      if (communities.exists) {
        throw 'Community with the same name already exists!';
      }
      return right(_communities.doc(community.name).set(community.toMap()));
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure.handleFirebaseException(e));
    } catch (e) {
      return Left(FirebaseFailure(e.toString()));
    }
  }
}

final communityRepoProvider = Provider(
  (ref) => CommunityRepoImpl(ref.read(firebaseFirestoreProvider)),
);
