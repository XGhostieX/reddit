import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import '../../features/auth/presentation/views/auth_view.dart';
import '../../features/home/presentation/views/home_view.dart';

final routes = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: AuthView()),
    '/home': (_) => const MaterialPage(child: HomeView()),
  },
);
