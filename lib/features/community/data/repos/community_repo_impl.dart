import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/models/community_model.dart';
import '../../../../core/models/post_model.dart';
import '../../../../core/utils/service_locator.dart';
import 'community_repo.dart';

class CommunityRepoImpl implements CommunityRepo {
  final FirebaseFirestore firebaseFirestore;

  CommunityRepoImpl(this.firebaseFirestore);

  CollectionReference get _communities => firebaseFirestore.collection('communities');
  CollectionReference get _posts => firebaseFirestore.collection('posts');

  @override
  Future<Either<Failure, void>> createCommunity(CommunityModel community) async {
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

  @override
  Stream<List<CommunityModel>> getUserCommunities(String uid) {
    return _communities.where('members', arrayContains: uid).snapshots().map((event) {
      List<CommunityModel> communities = [];
      for (var doc in event.docs) {
        communities.add(CommunityModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return communities;
    });
  }

  @override
  Stream<CommunityModel> getCommunity(String name) {
    return _communities
        .doc(Uri.decodeComponent(name))
        .snapshots()
        .map((event) => CommunityModel.fromMap(event.data() as Map<String, dynamic>));
  }

  @override
  Future<Either<Failure, void>> editCommunity(CommunityModel community) async {
    try {
      return right(_communities.doc(community.name).update(community.toMap()));
    } on FirebaseException catch (e) {
      return left(FirebaseFailure.handleFirebaseException(e));
    } catch (e) {
      return left(FirebaseFailure(e.toString()));
    }
  }

  @override
  Stream<List<CommunityModel>> searchCommunity(String query) {
    return _communities
        .where(
          'name',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                    String.fromCharCode(query.codeUnitAt(query.length - 1) + 1),
        )
        .snapshots()
        .map((event) {
          List<CommunityModel> communities = [];
          for (var community in event.docs) {
            communities.add(CommunityModel.fromMap(community.data() as Map<String, dynamic>));
          }
          return communities;
        });
  }

  @override
  Future<Either<Failure, void>> joinCommunity(String name, String uid) async {
    try {
      return right(
        _communities.doc(name).update({
          'members': FieldValue.arrayUnion([uid]),
        }),
      );
    } on FirebaseException catch (e) {
      return left(FirebaseFailure.handleFirebaseException(e));
    } catch (e) {
      return left(FirebaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> leaveCommunity(String name, String uid) async {
    try {
      return right(
        _communities.doc(name).update({
          'members': FieldValue.arrayRemove([uid]),
        }),
      );
    } on FirebaseException catch (e) {
      return left(FirebaseFailure.handleFirebaseException(e));
    } catch (e) {
      return left(FirebaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addMods(String name, List<String> uids) async {
    try {
      return right(_communities.doc(name).update({'mods': uids}));
    } on FirebaseException catch (e) {
      return left(FirebaseFailure.handleFirebaseException(e));
    } catch (e) {
      return left(FirebaseFailure(e.toString()));
    }
  }

  @override
  Stream<List<PostModel>> getCommunityPosts(String name) {
    return _posts
        .where('communityName', isEqualTo: name)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) =>
              event.docs.map((e) => PostModel.fromMap(e.data() as Map<String, dynamic>)).toList(),
        );
  }
}

final communityRepoProvider = Provider(
  (ref) => CommunityRepoImpl(ref.read(firebaseFirestoreProvider)),
);
