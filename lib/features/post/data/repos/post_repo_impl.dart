import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/models/comment_model.dart';
import '../../../../core/models/community_model.dart';
import '../../../../core/models/post_model.dart';
import '../../../../core/utils/service_locator.dart';
import 'post_repo.dart';

class PostRepoImpl implements PostRepo {
  final FirebaseFirestore firebaseFirestore;

  PostRepoImpl(this.firebaseFirestore);

  CollectionReference get _users => firebaseFirestore.collection('users');
  CollectionReference get _posts => firebaseFirestore.collection('posts');
  CollectionReference get _comments => firebaseFirestore.collection('comments');

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
  Stream<List<PostModel>> getGuestPosts() {
    return _posts
        .orderBy('createdAt', descending: true)
        .limit(10)
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

  @override
  Future<Either<Failure, void>> upvotePost(PostModel post, String uid) async {
    if (post.downvotes.contains(uid)) {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayRemove([uid]),
      });
    }
    if (post.upvotes.contains(uid)) {
      return right(
        _posts.doc(post.id).update({
          'upvotes': FieldValue.arrayRemove([uid]),
        }),
      );
    } else {
      return right(
        _posts.doc(post.id).update({
          'upvotes': FieldValue.arrayUnion([uid]),
        }),
      );
    }
  }

  @override
  Future<Either<Failure, void>> downvotePost(PostModel post, String uid) async {
    try {
      if (post.upvotes.contains(uid)) {
        _posts.doc(post.id).update({
          'upvotes': FieldValue.arrayRemove([uid]),
        });
      }
      if (post.downvotes.contains(uid)) {
        return right(
          _posts.doc(post.id).update({
            'downvotes': FieldValue.arrayRemove([uid]),
          }),
        );
      } else {
        return right(
          _posts.doc(post.id).update({
            'downvotes': FieldValue.arrayUnion([uid]),
          }),
        );
      }
    } on FirebaseException catch (e) {
      return left(FirebaseFailure.handleFirebaseException(e));
    } catch (e) {
      return left(FirebaseFailure(e.toString()));
    }
  }

  @override
  Stream<PostModel> getPost(String postId) {
    return _posts
        .doc(postId)
        .snapshots()
        .map((event) => PostModel.fromMap(event.data() as Map<String, dynamic>));
  }

  @override
  Future<Either<Failure, void>> addComment(CommentModel comment) async {
    try {
      await _comments.doc(comment.id).set(comment.toMap());
      return right(_posts.doc(comment.postId).update({'commentCount': FieldValue.increment(1)}));
    } on FirebaseException catch (e) {
      return left(FirebaseFailure.handleFirebaseException(e));
    } catch (e) {
      return left(FirebaseFailure(e.toString()));
    }
  }

  @override
  Stream<List<CommentModel>> getComments(String postId) {
    return _comments
        .where('postId', isEqualTo: postId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map((e) => CommentModel.fromMap(e.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  @override
  Future<Either<Failure, void>> deleteComment(CommentModel comment) async {
    try {
      await _comments.doc(comment.id).delete();
      return right(_posts.doc(comment.postId).update({'commentCount': FieldValue.increment(-1)}));
    } on FirebaseException catch (e) {
      return left(FirebaseFailure.handleFirebaseException(e));
    } catch (e) {
      return left(FirebaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> awardPost(PostModel post, String award, String uid) async {
    try {
      _posts.doc(post.id).update({
        'awards': FieldValue.arrayUnion([award]),
      });
      _users.doc(uid).update({
        'awards': FieldValue.arrayRemove([award]),
      });
      return right(
        _users.doc(post.uid).update({
          'awards': FieldValue.arrayUnion([award]),
        }),
      );
    } on FirebaseException catch (e) {
      return left(FirebaseFailure.handleFirebaseException(e));
    } catch (e) {
      return left(FirebaseFailure(e.toString()));
    }
  }
}

final postRepoProvider = Provider((ref) => PostRepoImpl(ref.read(firebaseFirestoreProvider)));
