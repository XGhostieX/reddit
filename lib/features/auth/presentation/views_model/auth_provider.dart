import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/models/user_model.dart';
import '../../../../core/utils/functions/display_message.dart';
import '../../../../core/utils/service_locator.dart';
import '../../data/repos/auth_repo.dart';

class AuthProvider {
  final AuthRepo authRepo;
  final Ref ref;

  AuthProvider(this.authRepo, this.ref);

  void signInWithGoogle() async {
    final auth = await authRepo.signInWithGoogle();
    auth.fold((failure) => displayMessage(failure.errMsg, true), (user) {
      ref.read(userProvider.notifier).update((state) => user);
      displayMessage('Welcome ${user.name}', false);
    });
  }
}

final authProvider = Provider(
  (ref) => AuthProvider(ref.read(authRepoProvider), ref),
);

final userProvider = StateProvider<UserModel?>((ref) => null);
