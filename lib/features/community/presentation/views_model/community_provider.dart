import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/models/community_model.dart';
import '../../../../core/models/post_model.dart';
import '../../../../core/utils/assets.dart';
import '../../../../core/utils/firebase_service.dart';
import '../../../../core/utils/functions/display_message.dart';
import '../../../auth/presentation/views_model/auth_provider.dart';
import '../../data/repos/community_repo.dart';
import '../../data/repos/community_repo_impl.dart';

class CommunityNotifier extends StateNotifier<bool> {
  final FirebaseService firebaseService;
  final CommunityRepo communityRepo;
  final Ref ref;

  CommunityNotifier(this.firebaseService, this.communityRepo, this.ref) : super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = ref.watch(userProvider)?.uid ?? '';
    final result = await communityRepo.createCommunity(
      CommunityModel(
        id: name,
        name: name,
        banner: Assets.banner,
        avatar: Assets.avatar,
        members: [uid],
        mods: [uid],
      ),
    );
    result.fold(
      (failure) {
        displayMessage(failure.errMsg, true);
        state = false;
      },
      (_) {
        displayMessage('$name Community Created Successfully', false);
        Routemaster.of(context).pop();
        state = false;
      },
    );
  }

  Stream<List<CommunityModel>> getUserCommunities() {
    return communityRepo.getUserCommunities(ref.read(userProvider)!.uid);
  }

  Stream<CommunityModel> getCommunity(String name) {
    return communityRepo.getCommunity(name);
  }

  Stream<List<CommunityModel>> searchCommunity(String query) {
    return communityRepo.searchCommunity(query);
  }

  void editCommunity({
    required CommunityModel community,
    required File? banner,
    required File? avatar,
    required BuildContext context,
  }) async {
    state = true;
    if (banner != null) {
      final result = await firebaseService.storeImage(
        path: 'communities/banner',
        id: community.name,
        image: banner,
      );
      result.fold(
        (failure) => displayMessage(failure.errMsg, true),
        (url) => community = community.copyWith(banner: url),
      );
    }
    if (avatar != null) {
      final result = await firebaseService.storeImage(
        path: 'communities/profile',
        id: community.name,
        image: avatar,
      );
      result.fold(
        (failure) => displayMessage(failure.errMsg, true),
        (url) => community = community.copyWith(avatar: url),
      );
    }
    final result = await communityRepo.editCommunity(community);
    state = false;
    result.fold((failure) => displayMessage(failure.errMsg, true), (_) {
      displayMessage('Community Updated Successfully', false);
      Routemaster.of(context).pop();
    });
  }

  void joinLeaveCommunity(CommunityModel community) async {
    final user = ref.read(userProvider)!;
    Either<Failure, void> result;
    if (community.members.contains(user.uid)) {
      result = await communityRepo.leaveCommunity(community.name, user.uid);
    } else {
      result = await communityRepo.joinCommunity(community.name, user.uid);
    }
    result.fold((failure) => displayMessage(failure.errMsg, true), (_) {
      if (community.members.contains(user.uid)) {
        displayMessage('/r${community.name} Community Left Successfully!', false);
      } else {
        displayMessage('/r${community.name} Community joined Successfully!', false);
      }
    });
  }

  void addMods(String name, List<String> uids, BuildContext context) async {
    final result = await communityRepo.addMods(name, uids);
    result.fold(
      (failure) => displayMessage(failure.errMsg, true),
      (_) => Routemaster.of(context).pop(),
    );
  }

  Stream<List<PostModel>> getCommunityPosts(String name) => communityRepo.getCommunityPosts(name);
}

final communityNotifierProvider = StateNotifierProvider<CommunityNotifier, bool>(
  (ref) =>
      CommunityNotifier(ref.read(firebaseServiceProvider), ref.read(communityRepoProvider), ref),
);

final userCommunitiesProvider = StreamProvider(
  (ref) => ref.watch(communityNotifierProvider.notifier).getUserCommunities(),
);

final getCommunityProvider = StreamProvider.family(
  (ref, String name) => ref.watch(communityNotifierProvider.notifier).getCommunity(name),
);

final searchCommunityProvider = StreamProvider.family(
  (ref, String query) => ref.watch(communityNotifierProvider.notifier).searchCommunity(query),
);

final getCommunityPostsProvider = StreamProvider.family(
  (ref, String name) => ref.watch(communityNotifierProvider.notifier).getCommunityPosts(name),
);
