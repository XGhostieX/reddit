import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../../core/utils/app_router.dart';
import '../../../../community/presentation/views_model/community_provider.dart';

class CommunityDrawer extends ConsumerWidget {
  const CommunityDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: const Text('Create a Community'),
              leading: const Icon(Icons.add_rounded),
              onTap: () =>
                  Routemaster.of(context).push(AppRouter.kCreateCommunity),
            ),
            ref
                .watch(userCommunitiesProvider)
                .when(
                  data: (communities) => Expanded(
                    child: ListView.builder(
                      itemCount: communities.length,
                      itemBuilder: (context, index) => ListTile(
                        leading: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                            communities[index].avatar,
                          ),
                        ),
                        title: Text('r/${communities[index].name}'),
                        onTap: () {},
                      ),
                    ),
                  ),
                  error: (error, stackTrace) => const Center(
                    child: Text(
                      'Something Wrong Happend, Please Try Again Later',
                    ),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                ),
          ],
        ),
      ),
    );
  }
}
