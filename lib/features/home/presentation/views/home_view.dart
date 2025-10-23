import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../feed/presentation/views/feed_view.dart';
import '../../../post/presentation/views/post_view.dart';
import 'widgets/community_drawer.dart';
import 'widgets/home_appbar.dart';
import 'widgets/profile_drawer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _page = 0;
  final tabsWidgets = const [FeedView(), PostView()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppbar(),
      body: tabsWidgets[_page],
      drawer: const CommunityDrawer(),
      endDrawer: const ProfileDrawer(),
      bottomNavigationBar: CupertinoTabBar(
        activeColor: AppColors.redColor,
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
