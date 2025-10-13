import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/assets.dart';
import '../../../../../core/widgets/rounded_btn.dart';
import '../../views_model/auth_provider.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const SizedBox(height: 30),
          const Text(
            'Dive Into Anything',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 30),
          Image.asset(
            Assets.emote,
            height: MediaQuery.sizeOf(context).height * 0.5,
            width: double.infinity,
          ),
          const SizedBox(height: 30),
          Consumer(
            builder: (context, ref, child) => RoundedBtn(
              label: 'Continue with Google',
              icon: Image.asset(Assets.google, height: 40),
              onPressed: () => ref.read(authProvider).signInWithGoogle(),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
