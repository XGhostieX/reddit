import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/assets.dart';
import '../views_model/auth_provider.dart';
import 'widgets/login.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(Assets.logo, height: 50),
        actions: [
          Consumer(
            builder: (context, ref, child) => TextButton(
              onPressed: () => ref.read(authNotifierProvider.notifier).signInAsGuest(),
              child: const Text('Skip', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: const Login(),
    );
  }
}
