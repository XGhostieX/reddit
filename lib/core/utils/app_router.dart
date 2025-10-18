import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import '../../features/auth/presentation/views/auth_view.dart';
import '../../features/community/presentation/views/community_view.dart';
import '../../features/community/presentation/views/widgets/create_community.dart';
import '../../features/home/presentation/views/home_view.dart';

abstract class AppRouter {
  static const kCommunityView = '/community';
  static const kCreateCommunity = '/create-community';
  static final loggedOutRoutes = RouteMap(
    routes: {'/': (_) => const MaterialPage(child: AuthView())},
  );
  static final loggedInRoutes = RouteMap(
    routes: {
      '/': (_) => const MaterialPage(child: HomeView()),
      kCommunityView: (_) => const MaterialPage(child: CommunityView()),
      kCreateCommunity: (_) => const MaterialPage(child: CreateCommunity()),
    },
  );
}
