import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import '../../features/auth/presentation/views/auth_view.dart';
import '../../features/community/presentation/views/community_view.dart';
import '../../features/community/presentation/views/widgets/add_mods.dart';
import '../../features/community/presentation/views/widgets/create_community.dart';
import '../../features/community/presentation/views/widgets/edit_community.dart';
import '../../features/community/presentation/views/widgets/mod_tools.dart';
import '../../features/home/presentation/views/home_view.dart';
import '../../features/profile/presentation/views/profile_view.dart';
import '../../features/profile/presentation/views/widgets/edit_profile.dart';

abstract class AppRouter {
  static const kCreateCommunity = '/create-community';
  static final loggedOutRoutes = RouteMap(
    routes: {'/': (_) => const MaterialPage(child: AuthView())},
  );
  static final loggedInRoutes = RouteMap(
    routes: {
      '/': (_) => const MaterialPage(child: HomeView()),
      kCreateCommunity: (_) => const MaterialPage(child: CreateCommunity()),
      '/r/:name': (route) =>
          MaterialPage(child: CommunityView(name: route.pathParameters['name']!)),
      '/mod-tools/:name': (route) =>
          MaterialPage(child: ModTools(name: route.pathParameters['name']!)),
      '/edit-community/:name': (route) =>
          MaterialPage(child: EditCommunity(name: route.pathParameters['name']!)),
      '/add-mods/:name': (route) =>
          MaterialPage(child: AddMods(name: route.pathParameters['name']!)),
      '/u/:uid': (route) => MaterialPage(child: ProfileView(uid: route.pathParameters['uid']!)),
      '/edit-profile/:uid': (route) =>
          MaterialPage(child: EditProfile(uid: route.pathParameters['uid']!)),
    },
  );
}
