import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../models/post_model.dart';
import '../utils/assets.dart';
import 'post_card.dart';

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
