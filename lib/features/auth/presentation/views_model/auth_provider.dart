import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/models/user_model.dart';
import '../../../../core/utils/functions/display_message.dart';
import '../../data/repos/auth_repo.dart';
import '../../data/repos/auth_repo_impl.dart';

class AuthNotifier extends StateNotifier<bool> {
  final AuthRepo authRepo;
  final Ref ref;

  AuthNotifier(this.authRepo, this.ref) : super(false);

  Stream<UserModel> getUser(String uid) => authRepo.getUser(uid);

  Stream<User?> get authStateChange => authRepo.authStateChange;

  void signInWithGoogle(bool fromGuest) async {
    state = true;
    final auth = await authRepo.signInWithGoogle(fromGuest);
    auth.fold(
      (failure) {
        state = false;
        displayMessage(failure.errMsg, true);
      },
      (user) {
        state = false;
        ref.read(userProvider.notifier).update((state) => user);
        displayMessage('Welcome ${user.name}', false);
      },
    );
  }

  void signInAsGuest() async {
    state = true;
    final auth = await authRepo.signInAsGuest();
    auth.fold(
      (failure) {
        state = false;
        displayMessage(failure.errMsg, true);
      },
      (user) {
        state = false;
        ref.read(userProvider.notifier).update((state) => user);
        displayMessage('Welcome ${user.name}', false);
      },
    );
  }

  void signOut() async {
    final result = await authRepo.signOut();
    result.fold(
      (failure) => displayMessage(failure.errMsg, true),
      (_) => displayMessage('Sign Out Successfully', false),
    );
  }
}

final authNotifierProvider = StateNotifierProvider(
  (ref) => AuthNotifier(ref.watch(authRepoProvider), ref),
);

final userProvider = StateProvider<UserModel?>((ref) => null);

final authStateChangeProvider = StreamProvider((ref) {
  final authNotifier = ref.watch(authNotifierProvider.notifier);
  return authNotifier.authStateChange;
});

final getUserProvider = StreamProvider.family((ref, String uid) {
  final authNotifier = ref.watch(authNotifierProvider.notifier);
  return authNotifier.getUser(uid);
});
