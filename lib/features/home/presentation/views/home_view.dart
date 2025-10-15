import 'package:flutter/material.dart';

import 'widgets/community_drawer.dart';
import 'widgets/home_appbar.dart';
import 'widgets/home_view_body.dart';
import 'widgets/profile_drawer.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HomeAppbar(),
      body: HomeViewBody(),
      drawer: CommunityDrawer(),
      endDrawer: ProfileDrawer(),
    );
  }
}
