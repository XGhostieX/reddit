import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../core/models/user_model.dart';
import '../../../../core/utils/functions/display_message.dart';
import '../../../../core/utils/service_locator.dart';
import '../../data/repos/auth_repo.dart';

class AuthNotifier {
  final AuthRepo authRepo;
  final Ref ref;

  AuthNotifier(this.authRepo, this.ref);

  void signInWithGoogle(BuildContext context) async {
    final auth = await authRepo.signInWithGoogle();
    auth.fold((failure) => displayMessage(failure.errMsg, true), (user) {
      ref.read(userProvider.notifier).update((state) => user);
      displayMessage('Welcome ${user.name}', false);
      Routemaster.of(context).replace('/home');
    });
  }
}

final authNotifierProvider = Provider(
  (ref) => AuthNotifier(ref.watch(authRepoProvider), ref),
);

final userProvider = StateProvider<UserModel?>((ref) => null);
