import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/service_locator.dart';
import '../../data/repos/auth_repo.dart';

class AuthProvider {
  final AuthRepo authRepo;

  AuthProvider(this.authRepo);

  void signInWithGoogle() {
    authRepo.signInWithGoogle();
  }
}

final authProvider = Provider(
  (ref) => AuthProvider(ref.read(authRepoProvider)),
);
