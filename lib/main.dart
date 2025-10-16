import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import 'core/theme/app_theme.dart';
import 'core/utils/app_router.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: Reddit()));
}

class Reddit extends StatelessWidget {
  const Reddit({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return MaterialApp.router(
      title: 'Reddit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerDelegate: RoutemasterDelegate(
        routesBuilder: (context) => AppRouter.routes,
      ),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const ProviderScope(child: MyApp()));
// }

// class MyApp extends ConsumerWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return ref
//         .watch(authStateChangeProvider)
//         .when(
//           data: (data) => MaterialApp.router(
//             title: 'Reddit',
//             debugShowCheckedModeBanner: false,
//             theme: AppTheme.darkTheme,
//             routerDelegate: RoutemasterDelegate(
//               routesBuilder: (context) => loggedOutRoutes,
//             ),
//             routeInformationParser: const RoutemasterParser(),
//           ),
//           error: (error, stackTrace) => const Center(
//             child: Text('Something Wrong Happend, Please Try Again Later'),
//           ),
//           loading: () => const Center(child: CircularProgressIndicator()),
//         );
//   }
// }
