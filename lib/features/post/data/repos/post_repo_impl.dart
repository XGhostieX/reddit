import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/models/community_model.dart';
import '../../../../core/models/post_model.dart';
import '../../../../core/utils/service_locator.dart';
import 'post_repo.dart';

class PostRepoImpl implements PostRepo {
  final FirebaseFirestore firebaseFirestore;

  PostRepoImpl(this.firebaseFirestore);

  CollectionReference get _posts => firebaseFirestore.collection('posts');

  @override
  Future<Either<Failure, void>> addPost(PostModel post) async {
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      return left(FirebaseFailure.handleFirebaseException(e));
    } catch (e) {
      return left(FirebaseFailure(e.toString()));
    }
  }

  @override
  Stream<List<PostModel>> getPosts(List<CommunityModel> communities) {
    return _posts
        .where('communityName', whereIn: communities.map((e) => e.name).toList())
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) =>
              event.docs.map((e) => PostModel.fromMap(e.data() as Map<String, dynamic>)).toList(),
        );
  }

  @override
  Future<Either<Failure, void>> deletePost(PostModel post) async {
    try {
      return right(_posts.doc(post.id).delete());
    } on FirebaseException catch (e) {
      return left(FirebaseFailure.handleFirebaseException(e));
    } catch (e) {
      return left(FirebaseFailure(e.toString()));
    }
  }
}

final postRepoProvider = Provider((ref) => PostRepoImpl(ref.read(firebaseFirestoreProvider)));
