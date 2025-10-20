import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../auth/presentation/views_model/auth_provider.dart';
import '../../views_model/community_provider.dart';

class CommunityViewBody extends ConsumerWidget {
  final String name;
  const CommunityViewBody({super.key, required this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return ref
        .watch(getCommunityProvider(name))
        .when(
          data: (community) => NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                expandedHeight: 150,
                floating: true,
                snap: true,
                flexibleSpace: Stack(
                  children: [
                    Positioned.fill(
                      child: CachedNetworkImage(imageUrl: community.banner, fit: BoxFit.cover),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Align(
                      alignment: Alignment.topLeft,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: CachedNetworkImageProvider(community.avatar),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'r/${community.name}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          community.mods.contains(user!.uid)
                              ? OutlinedButton(
                                  onPressed: () => Routemaster.of(context).push('/mod-tools/$name'),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadiusGeometry.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 25),
                                  ),
                                  child: const Text('Mod Tools'),
                                )
                              : OutlinedButton(
                                  onPressed: () => ref
                                      .watch(communityNotifierProvider.notifier)
                                      .joinLeaveCommunity(community),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadiusGeometry.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 25),
                                  ),
                                  child: Text(
                                    community.members.contains(user.uid) ? 'Leave' : 'Join',
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        community.members.length == 1
                            ? '${community.members.length} Member'
                            : '${community.members.length} Member',
                      ),
                    ),
                  ]),
                ),
              ),
            ],
            body: const Text('Posts'),
          ),
          error: (error, stackTrace) =>
              const Center(child: Text('Something Wrong Happend, Please Try Again Later')),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
  }
}
