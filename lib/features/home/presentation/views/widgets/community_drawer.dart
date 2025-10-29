import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../../core/utils/app_router.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../../core/widgets/rounded_btn.dart';
import '../../../../auth/presentation/views_model/auth_provider.dart';
import '../../../../community/presentation/views_model/community_provider.dart';
import 'communities_listview.dart';

class CommunityDrawer extends ConsumerWidget {
  const CommunityDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGuest = !ref.read(userProvider)!.isAuthenticated;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            isGuest
                ? RoundedBtn(
                    label: ref.watch(authNotifierProvider) ? '' : 'Sign In with Google',
                    icon: ref.watch(authNotifierProvider)
                        ? const CircularProgressIndicator()
                        : Image.asset(Assets.google, height: 40),
                    onPressed: ref.watch(authNotifierProvider)
                        ? () {}
                        : () => ref.read(authNotifierProvider.notifier).signInWithGoogle(true),
                  )
                : ListTile(
                    title: const Text('Create a Community'),
                    leading: const Icon(Icons.add_rounded),
                    onTap: () => Routemaster.of(context).push(AppRouter.kCreateCommunity),
                  ),
            if (!isGuest)
              ref
                  .watch(userCommunitiesProvider)
                  .when(
                    data: (communities) =>
                        Expanded(child: CommunitiesListview(communities: communities)),
                    error: (error, stackTrace) => const Center(
                      child: Text('Something Wrong Happend, Please Try Again Later'),
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                  ),
          ],
        ),
      ),
    );
  }
}
