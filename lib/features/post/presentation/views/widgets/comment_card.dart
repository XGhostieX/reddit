import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../../core/models/comment_model.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../auth/presentation/views_model/auth_provider.dart';

class CommentCard extends ConsumerWidget {
  final CommentModel comment;
  const CommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider)!;
    final theme = ref.watch(themeNotifierProvider);
    return Container(
      padding: const EdgeInsets.all(10).copyWith(bottom: 0),
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
                onTap: () => Routemaster.of(context).push('/u/${comment.uid}'),
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(comment.profile),
                  radius: 20,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Routemaster.of(context).push('/u/${comment.uid}'),
                      child: Text(
                        'u/${comment.username}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(comment.text),
                  ],
                ),
              ),
              const Spacer(),
              if (comment.uid == user.uid)
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.delete_rounded, color: AppColors.redColor),
                ),
            ],
          ),
          TextButton.icon(
            onPressed: () {},
            label: const Text('Reply'),
            icon: const Icon(Icons.reply_rounded),
          ),
        ],
      ),
    );
  }
}
