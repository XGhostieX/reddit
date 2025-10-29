import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../../core/widgets/feed_skeleton.dart';
import '../../../../../core/widgets/post_card.dart';
import '../../../../auth/presentation/views_model/auth_provider.dart';
import '../../views_model/profile_provider.dart';

class ProfileViewBody extends ConsumerWidget {
  final String uid;
  const ProfileViewBody({super.key, required this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.read(userProvider)!;
    return ref
        .watch(getUserProvider(uid))
        .when(
          data: (user) => NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                expandedHeight: 250,
                floating: true,
                snap: true,
                flexibleSpace: Stack(
                  children: [
                    Positioned.fill(
                      child: CachedNetworkImage(imageUrl: user.banner, fit: BoxFit.cover),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.all(20),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: CachedNetworkImageProvider(user.profile),
                      ),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'u/${user.name}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          if (currentUser.uid == user.uid)
                            OutlinedButton(
                              onPressed: () =>
                                  Routemaster.of(context).push('/edit-profile/${user.uid}'),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 25),
                              ),
                              child: const Text('Edit Profile'),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text('${user.karma} Karma'),
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 2),
                  ]),
                ),
              ),
            ],
            body: ref
                .watch(getUserPostsProvider(user.uid))
                .when(
                  data: (posts) => ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) => PostCard(post: posts[index]),
                  ),
                  error: (error, stackTrace) =>
                      const Center(child: Text('Something Wrong Happend, Please Try Again Later')),
                  loading: () => const FeedSkeleton(),
                ),
          ),
          error: (error, stackTrace) =>
              const Center(child: Text('Something Wrong Happend, Please Try Again Later')),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
  }
}
