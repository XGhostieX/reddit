import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../feed/presentation/views/feed_view.dart';
import '../../../post/presentation/views/post_view.dart';
import 'widgets/community_drawer.dart';
import 'widgets/home_appbar.dart';
import 'widgets/profile_drawer.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  int _page = 0;
  final tabsWidgets = const [FeedView(), PostView()];
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: const HomeAppbar(),
      body: tabsWidgets[_page],
      drawer: const CommunityDrawer(),
      endDrawer: const ProfileDrawer(),
      bottomNavigationBar: CupertinoTabBar(
        activeColor: AppColors.redColor,
        backgroundColor: theme.colorScheme.surface,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded)),
          BottomNavigationBarItem(icon: Icon(Icons.add_rounded)),
        ],
        onTap: (value) {
          setState(() {
            _page = value;
          });
        },
        currentIndex: _page,
      ),
    );
  }
}
