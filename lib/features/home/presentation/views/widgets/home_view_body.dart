import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/widgets/feed_skeleton.dart';
import '../../../../../core/widgets/post_card.dart';
import '../../../../auth/presentation/views_model/auth_provider.dart';
import '../../../../community/presentation/views_model/community_provider.dart';
import '../../../../post/presentation/views_model/post_provider.dart';

class HomeViewBody extends ConsumerWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGuest = !ref.read(userProvider)!.isAuthenticated;
    if (!isGuest) {
      return ref
          .watch(userCommunitiesProvider)
          .when(
            data: (communities) => ref
                .watch(getPostsProvider(communities))
                .when(
                  data: (posts) => ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) => PostCard(post: posts[index]),
                  ),
                  error: (error, stackTrace) =>
                      const Center(child: Text('Something Wrong Happend, Please Try Again Later')),
                  loading: () => const FeedSkeleton(),
                ),
            error: (error, stackTrace) =>
                const Center(child: Text('Something Wrong Happend, Please Try Again Later')),
            loading: () => const FeedSkeleton(),
          );
    }
    return ref
        .watch(getGuestPostsProvider)
        .when(
          data: (posts) => ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) => PostCard(post: posts[index]),
          ),
          error: (error, stackTrace) =>
              const Center(child: Text('Something Wrong Happend, Please Try Again Later')),
          loading: () => const FeedSkeleton(),
        );
  }
}
