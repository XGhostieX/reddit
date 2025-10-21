import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../core/models/user_model.dart';
import '../../../../core/utils/firebase_service.dart';
import '../../../../core/utils/functions/display_message.dart';
import '../../../auth/presentation/views_model/auth_provider.dart';
import '../../data/repos/profile_repo.dart';
import '../../data/repos/profile_repo_impl.dart';

class ProfileNotifier extends StateNotifier<bool> {
  final FirebaseService firebaseService;
  final ProfileRepo profileRepo;
  final Ref ref;

  ProfileNotifier(this.firebaseService, this.profileRepo, this.ref) : super(false);

  void editProfile({
    required File? banner,
    required File? profile,
    required String name,
    required BuildContext context,
  }) async {
    UserModel user = ref.read(userProvider)!;
    state = true;
    if (banner != null) {
      final result = await firebaseService.storeImage(
        path: 'users/banner',
        id: user.uid,
        image: banner,
      );
      result.fold(
        (failure) => displayMessage(failure.errMsg, true),
        (url) => user = user.copyWith(banner: url),
      );
    }
    if (profile != null) {
      final result = await firebaseService.storeImage(
        path: 'users/profile',
        id: user.uid,
        image: profile,
      );
      result.fold(
        (failure) => displayMessage(failure.errMsg, true),
        (url) => user = user.copyWith(profile: url),
      );
    }
    user = user.copyWith(name: name);
    final result = await profileRepo.editProfile(user);
    state = false;
    result.fold((failure) => displayMessage(failure.errMsg, true), (_) {
      ref.read(userProvider.notifier).update((state) => user);
      displayMessage('Profile Updated Successfully', false);
      Routemaster.of(context).pop();
    });
  }
}

final profileNotifierProvider = StateNotifierProvider<ProfileNotifier, bool>(
  (ref) => ProfileNotifier(ref.read(firebaseServiceProvider), ref.read(profileRepoProvider), ref),
);
