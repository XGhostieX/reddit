import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/functions/display_message.dart';
import '../../../../core/utils/service_locator.dart';
import '../../data/repos/auth_repo.dart';

class AuthProvider {
  final AuthRepo authRepo;

  AuthProvider(this.authRepo);

  void signInWithGoogle() async {
    final auth = await authRepo.signInWithGoogle();
    auth.fold((failure) => displayMessage(failure.errMsg, true), (user) {
      displayMessage('Welcome ${user.name}', false);
    });
  }
}

final authProvider = Provider(
  (ref) => AuthProvider(ref.read(authRepoProvider)),
);
