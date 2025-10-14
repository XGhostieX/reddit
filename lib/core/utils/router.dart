import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import '../../features/auth/presentation/views/auth_view.dart';

final loggedOutRoutes = RouteMap(
  routes: {'/': (_) => const MaterialPage(child: AuthView())},
);
