import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../core/models/comment_model.dart';
import '../../../../core/models/community_model.dart';
import '../../../../core/models/post_model.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/firebase_service.dart';
import '../../../../core/utils/functions/display_message.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../auth/presentation/views_model/auth_provider.dart';
import '../../../profile/presentation/views_model/profile_provider.dart';
import '../../data/repos/post_repo.dart';
import '../../data/repos/post_repo_impl.dart';

class PostNotifier extends StateNotifier<bool> {
  final FirebaseService firebaseService;
  final PostRepo postRepo;
  final Ref ref;
  late final user = ref.read(userProvider)!;

  PostNotifier(this.firebaseService, this.postRepo, this.ref) : super(false);

  void addPost({
    required BuildContext context,
    required String title,
    required CommunityModel community,
    required String? description,
    required String? link,
    required File? image,
  }) async {
    state = true;
    final postId = ref.read(uuidProvider).v1();
    if (image != null) {
      final imageResult = await firebaseService.storeImage(
        path: 'posts/${community.name}',
        id: postId,
        image: image,
      );
      imageResult.fold((failure) => displayMessage(failure.errMsg, true), (image) async {
        final result = await postRepo.addPost(
          PostModel(
            id: postId,
            title: title,
            communityName: community.name,
            communityAvatar: community.avatar,
            upvotes: [],
            downvotes: [],
            commentCount: 0,
            username: ref.read(userProvider)!.name,
            uid: ref.read(userProvider)!.uid,
            createdAt: DateTime.now(),
            awards: [],
            description: description,
            image: image,
            link: link,
          ),
        );
        ref.read(profileNotifierProvider.notifier).updateKarma(UserKarma.imagePost);
        state = false;
        result.fold((failure) => displayMessage(failure.errMsg, true), (_) {
          displayMessage('Posted Successfully!', false);
          Routemaster.of(context).pop();
        });
      });
    } else {
      final result = await postRepo.addPost(
        PostModel(
          id: postId,
          title: title,
          communityName: community.name,
          communityAvatar: community.avatar,
          upvotes: [],
          downvotes: [],
          commentCount: 0,
          username: ref.read(userProvider)!.name,
          uid: ref.read(userProvider)!.uid,
          createdAt: DateTime.now(),
          awards: [],
          description: description,
          image: null,
          link: link,
        ),
      );
      ref.read(profileNotifierProvider.notifier).updateKarma(UserKarma.textPost);
      state = false;
      result.fold((failure) => displayMessage(failure.errMsg, true), (_) {
        displayMessage('Posted Successfully!', false);
        Routemaster.of(context).pop();
      });
    }
  }

  Stream<List<PostModel>> getPosts(List<CommunityModel> communities) {
    if (communities.isEmpty) {
      return Stream.value([]);
    }
    return postRepo.getPosts(communities);
  }

  Stream<List<PostModel>> getGuestPosts() => postRepo.getGuestPosts();

  Stream<PostModel> getPost(String postId) => postRepo.getPost(postId);

  void deletePost(PostModel post) async {
    if (post.image != null || post.image!.isNotEmpty) {
      final imageResult = await firebaseService.deleteImage(
        path: 'posts/${post.communityName}',
        id: post.id,
      );
      imageResult.fold((failure) => displayMessage(failure.errMsg, true), (_) {});
    }
    final result = await postRepo.deletePost(post);
    ref.read(profileNotifierProvider.notifier).updateKarma(UserKarma.deletePost);
    result.fold(
      (failure) => displayMessage(failure.errMsg, true),
      (_) => displayMessage('Post Deleted Successfully!', false),
    );
  }

  void upvotePost(PostModel post, String uid) async {
    final result = await postRepo.upvotePost(post, uid);
    result.fold((failure) => displayMessage(failure.errMsg, true), (_) {});
  }

  void downvotePost(PostModel post, String uid) async {
    final result = await postRepo.downvotePost(post, uid);
    result.fold((failure) => displayMessage(failure.errMsg, true), (_) {});
  }

  void addComment(String text, String postId) async {
    final result = await postRepo.addComment(
      CommentModel(
        id: ref.read(uuidProvider).v1(),
        text: text,
        createdAt: DateTime.now(),
        postId: postId,
        uid: user.uid,
        username: user.name,
        profile: user.profile,
      ),
    );
    ref.read(profileNotifierProvider.notifier).updateKarma(UserKarma.comment);
    result.fold((failure) => displayMessage(failure.errMsg, true), (_) {});
  }

  Stream<List<CommentModel>> getComments(String postId) {
    return postRepo.getComments(postId);
  }

  void deleteComment(CommentModel comment) async {
    final result = await postRepo.deleteComment(comment);
    ref.read(profileNotifierProvider.notifier).updateKarma(UserKarma.deleteComment);
    result.fold((failure) => displayMessage(failure.errMsg, true), (_) {});
  }

  void awardPost(PostModel post, String award, BuildContext context) async {
    final result = await postRepo.awardPost(post, award, user.uid);
    result.fold((failure) => displayMessage(failure.errMsg, true), (_) {
      ref.read(profileNotifierProvider.notifier).updateKarma(UserKarma.awardPost);
      ref.read(userProvider.notifier).update((state) {
        state?.awards.remove(award);
        return state;
      });
      Routemaster.of(context).pop();
    });
  }
}

final postNotifierProvider = StateNotifierProvider<PostNotifier, bool>(
  (ref) => PostNotifier(ref.read(firebaseServiceProvider), ref.read(postRepoProvider), ref),
);

final getPostsProvider = StreamProvider.family(
  (ref, List<CommunityModel> communities) =>
      ref.watch(postNotifierProvider.notifier).getPosts(communities),
);

final getGuestPostsProvider = StreamProvider(
  (ref) => ref.watch(postNotifierProvider.notifier).getGuestPosts(),
);

final getPostProvider = StreamProvider.family(
  (ref, String postId) => ref.watch(postNotifierProvider.notifier).getPost(postId),
);

final getCommentsProvider = StreamProvider.family(
  (ref, String postId) => ref.watch(postNotifierProvider.notifier).getComments(postId),
);
