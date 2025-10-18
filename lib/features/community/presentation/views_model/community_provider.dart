import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../core/models/community_model.dart';
import '../../../../core/utils/assets.dart';
import '../../../../core/utils/functions/display_message.dart';
import '../../../auth/presentation/views_model/auth_provider.dart';
import '../../data/repos/community_repo.dart';
import '../../data/repos/community_repo_impl.dart';

class CommunityNotifier extends StateNotifier<bool> {
  final CommunityRepo communityRepo;
  final Ref ref;

  CommunityNotifier(this.communityRepo, this.ref) : super(false);

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
        state = false;
        displayMessage(failure.errMsg, true);
      },
      (r) {
        state = false;
        displayMessage('$name Community Created Successfully', false);
        Routemaster.of(context).pop();
      },
    );
  }
}

final communityNotifierProvider =
    StateNotifierProvider<CommunityNotifier, bool>(
      (ref) => CommunityNotifier(ref.watch(communityRepoProvider), ref),
    );
