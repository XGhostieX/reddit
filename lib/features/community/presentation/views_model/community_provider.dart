import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repos/community_repo.dart';
import '../../data/repos/community_repo_impl.dart';

class CommunityNotifier {
  final CommunityRepo communityRepo;

  CommunityNotifier(this.communityRepo);
}

final communityNotifierProvider = Provider(
  (ref) => CommunityNotifier(ref.watch(communityRepoProvider)),
);
