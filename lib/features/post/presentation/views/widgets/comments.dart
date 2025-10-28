import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/functions/display_message.dart';
import '../../../../../core/widgets/post_card.dart';
import '../../views_model/post_provider.dart';
import 'comment_card.dart';

class Comments extends ConsumerStatefulWidget {
  final String postId;
  const Comments({super.key, required this.postId});

  @override
  ConsumerState<Comments> createState() => _CommentsState();
}

class _CommentsState extends ConsumerState<Comments> {
  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(),
      body: ref
          .watch(getPostProvider(widget.postId))
          .when(
            data: (post) => Column(
              children: [
                PostCard(post: post),
                const SizedBox(height: 10),
                ref
                    .watch(getCommentsProvider(post.id))
                    .when(
                      data: (comments) => Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) => CommentCard(comment: comments[index]),
                          separatorBuilder: (context, index) => const SizedBox(height: 10),
                          itemCount: comments.length,
                        ),
                      ),
                      error: (error, stackTrace) => const Center(
                        child: Text('Something Wrong Happend, Please Try Again Later'),
                      ),
                      loading: () => const Center(child: CircularProgressIndicator()),
                    ),
              ],
            ),
            error: (error, stackTrace) =>
                const Center(child: Text('Something Wrong Happend, Please Try Again Later')),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10).copyWith(left: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: theme.drawerTheme.backgroundColor,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: commentController,
                decoration: const InputDecoration(
                  hintText: 'Write a Comment...',
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                if (commentController.text.isEmpty) {
                  displayMessage('Please Enter a Comment!', true);
                } else {
                  ref
                      .read(postNotifierProvider.notifier)
                      .addComment(commentController.text.trim(), widget.postId);
                  setState(() {
                    commentController.text = '';
                  });
                }
              },
              icon: const Icon(Icons.send_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
