import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../core/models/community_model.dart';
import '../../../../core/models/post_model.dart';
import '../../../../core/utils/firebase_service.dart';
import '../../../../core/utils/functions/display_message.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../auth/presentation/views_model/auth_provider.dart';
import '../../data/repos/post_repo.dart';
import '../../data/repos/post_repo_impl.dart';

class PostNotifier extends StateNotifier<bool> {
  final FirebaseService firebaseService;
  final PostRepo postRepo;
  final Ref ref;

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
}

final postNotifierProvider = StateNotifierProvider<PostNotifier, bool>(
  (ref) => PostNotifier(ref.read(firebaseServiceProvider), ref.read(postRepoProvider), ref),
);

final getPostsProvider = StreamProvider.family(
  (ref, List<CommunityModel> communities) =>
      ref.watch(postNotifierProvider.notifier).getPosts(communities),
);
