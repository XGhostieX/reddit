import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../auth/presentation/views_model/auth_provider.dart';
import '../delegates/search_community_delegate.dart';

class HomeAppbar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return AppBar(
      title: const Text('Home'),
      centerTitle: false,
      leading: IconButton(
        onPressed: () => Scaffold.of(context).openDrawer(),
        icon: const Icon(Icons.menu_rounded),
      ),
      actions: [
        IconButton(
          onPressed: () => showSearch(context: context, delegate: SearchCommunityDelegate()),
          icon: const Icon(Icons.search_rounded),
        ),
        IconButton(
          onPressed: () => Scaffold.of(context).openEndDrawer(),
          icon: CircleAvatar(backgroundImage: CachedNetworkImageProvider(user!.profile)),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
