import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../auth/presentation/views_model/auth_provider.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            CircleAvatar(backgroundImage: CachedNetworkImageProvider(user.profile), radius: 70),
            const SizedBox(height: 10),
            Text(
              'u/${user.name}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person_rounded),
              title: const Text('My Profile'),
              onTap: () => Routemaster.of(context).push('/u/${user.uid}'),
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode_rounded),
              title: const Text('Dark Theme'),
              trailing: Switch.adaptive(value: true, onChanged: (value) {}),
            ),
            ListTile(
              leading: Icon(Icons.logout_rounded, color: AppColors.redColor),
              title: const Text('Sign Out'),
              onTap: () => ref.read(authNotifierProvider.notifier).signOut(),
            ),
          ],
        ),
      ),
    );
  }
}
