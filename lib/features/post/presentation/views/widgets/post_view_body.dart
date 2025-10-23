import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../../core/theme/app_theme.dart';

class PostViewBody extends StatelessWidget {
  const PostViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        PostCard(icon: Icons.image_outlined, type: 'image'),
        PostCard(icon: Icons.font_download_outlined, type: 'text'),
        PostCard(icon: Icons.link_outlined, type: 'link'),
      ],
    );
  }
}

class PostCard extends ConsumerWidget {
  const PostCard({super.key, required this.icon, required this.type});

  final IconData icon;
  final String type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeNotifierProvider);
    return GestureDetector(
      onTap: () => Routemaster.of(context).push('/add-post/$type'),
      child: SizedBox(
        width: 100,
        height: 100,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10)),
          elevation: 16,
          color: theme.colorScheme.surface,
          child: Center(child: Icon(icon, size: 50)),
        ),
      ),
    );
  }
}
