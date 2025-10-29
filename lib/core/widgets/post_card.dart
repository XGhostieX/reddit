import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readmore/readmore.dart';
import 'package:routemaster/routemaster.dart';

import '../../features/auth/presentation/views_model/auth_provider.dart';
import '../../features/community/presentation/views_model/community_provider.dart';
import '../../features/post/presentation/views_model/post_provider.dart';
import '../models/post_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../utils/assets.dart';

class PostCard extends ConsumerWidget {
  final PostModel post;
  const PostCard({super.key, required this.post});

  void deletePost(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text('Delete Post'),
        content: Text('Are you sure you want to delete "${post.title}" ?'),
        actions: [
          TextButton(onPressed: () => Routemaster.of(context).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              ref.read(postNotifierProvider.notifier).deletePost(post);
              Routemaster.of(context).pop();
            },
            child: Text('Delete', style: TextStyle(color: AppColors.redColor)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final theme = ref.watch(themeNotifierProvider);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.drawerTheme.backgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () => Routemaster.of(context).push('/r/${post.communityName}'),
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(post.communityAvatar),
                  radius: 20,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Routemaster.of(context).push('/r/${post.communityName}'),
                      child: Text(
                        'r/${post.communityName}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Routemaster.of(context).push('/u/${post.uid}'),
                      child: Text('u/${post.username}', style: const TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (post.uid == user.uid)
                IconButton(
                  onPressed: () => deletePost(context, ref),
                  icon: Icon(Icons.delete_rounded, color: AppColors.redColor),
                ),
            ],
          ),
          const SizedBox(height: 10),
          if (post.awards.isNotEmpty)
            SizedBox(
              height: 25,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => Image.asset(Assets.awards[post.awards[index]]!),
                separatorBuilder: (context, index) => const SizedBox(width: 5),
                itemCount: post.awards.length,
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              post.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          if (post.description != null)
            Padding(
              padding: const EdgeInsets.all(10),
              child: ReadMoreText(
                post.description!,
                trimMode: TrimMode.Line,
                trimLines: 2,
                colorClickableText: AppColors.redColor,
                trimCollapsedText: 'Show more',
                trimExpandedText: 'Show less',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          if (post.image!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: post.image!,
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height * 0.35,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          if (post.link != null)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height * 0.25,
              child: AnyLinkPreview(
                link: post.link!,
                displayDirection: UIDirection.uiDirectionHorizontal,
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () =>
                        ref.read(postNotifierProvider.notifier).upvotePost(post, user.uid),
                    icon: Image.asset(
                      height: 20,
                      width: 20,
                      Assets.upvote,
                      color: post.upvotes.contains(user.uid)
                          ? AppColors.redColor
                          : theme.iconTheme.color,
                    ),
                  ),
                  Text(
                    '${post.upvotes.length - post.downvotes.length == 0 ? 'Vote' : post.upvotes.length - post.downvotes.length}',
                    style: const TextStyle(fontSize: 17),
                  ),
                  IconButton(
                    onPressed: () =>
                        ref.read(postNotifierProvider.notifier).downvotePost(post, user.uid),
                    icon: Image.asset(
                      Assets.downvote,
                      height: 20,
                      width: 20,
                      color: post.downvotes.contains(user.uid)
                          ? AppColors.blueColor
                          : theme.iconTheme.color,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () => Routemaster.of(context).push('/post/${post.id}/comments'),
                label: Text(
                  '${post.commentCount == 0 ? 'Comment' : post.commentCount}',
                  style: const TextStyle(fontSize: 17),
                ),
                icon: const Icon(Icons.comment_rounded),
              ),
              IconButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                        ),
                        itemCount: user.awards.length,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () => ref
                              .read(postNotifierProvider.notifier)
                              .awardPost(post, user.awards[index], context),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(Assets.awards[user.awards[index]]!),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                icon: const Icon(Icons.card_giftcard_rounded),
              ),
              ref
                  .watch(getCommunityProvider(post.communityName))
                  .when(
                    data: (community) {
                      if (community.mods.contains(user.uid)) {
                        return IconButton(
                          onPressed: () => deletePost(context, ref),
                          icon: const Icon(Icons.admin_panel_settings_rounded),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                    error: (error, stackTrace) => const Center(
                      child: Text('Something Wrong Happend, Please Try Again Later'),
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
