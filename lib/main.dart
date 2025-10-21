import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import 'core/models/user_model.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_router.dart';
import 'features/auth/presentation/views_model/auth_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: Reddit()));
}

class Reddit extends ConsumerStatefulWidget {
  const Reddit({super.key});

  @override
  ConsumerState<Reddit> createState() => _RedditState();
}

class _RedditState extends ConsumerState<Reddit> {
  UserModel? user;

  void getData(User data) async {
    user = await ref.watch(authNotifierProvider.notifier).getUser(data.uid).first;
    ref.read(userProvider.notifier).update((state) => user);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref
        .watch(authStateChangeProvider)
        .when(
          data: (data) => MaterialApp.router(
            title: 'Reddit',
            debugShowCheckedModeBanner: false,
            theme: ref.watch(themeNotifierProvider),
            routerDelegate: RoutemasterDelegate(
              routesBuilder: (context) {
                if (data != null) {
                  getData(data);
                  if (user != null) {
                    return AppRouter.loggedInRoutes;
                  }
                }
                return AppRouter.loggedOutRoutes;
              },
            ),
            routeInformationParser: const RoutemasterParser(),
          ),
          error: (error, stackTrace) =>
              const Center(child: Text('Something Wrong Happend, Please Try Again Later')),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
  }
}
