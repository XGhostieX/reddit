import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../auth/presentation/views_model/auth_provider.dart';

class PostViewBody extends ConsumerWidget {
  const PostViewBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Center(child: Text('Post ${user!.name}'));
  }
}
