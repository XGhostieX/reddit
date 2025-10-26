import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/models/post_model.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../../core/widgets/post_card.dart';
import '../../../../community/presentation/views_model/community_provider.dart';
import '../../../../post/presentation/views_model/post_provider.dart';

class HomeViewBody extends ConsumerWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
}

class FeedSkeleton extends StatelessWidget {
  const FeedSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => PostCard(
          post: PostModel(
            id: 'id',
            title: 'title',
            communityName: 'communityName',
            communityAvatar: Assets.avatar,
            upvotes: ['upvotes'],
            downvotes: ['downvotes'],
            commentCount: 0,
            username: 'username',
            uid: 'uid',
            createdAt: DateTime.now(),
            awards: ['awards'],
            description: 'description',
            image: '',
            link: 'https://youtu.be/1F3OGIFnW1k?si=yor6xyHMXDmjLADs',
          ),
        ),
      ),
    );
  }
}
