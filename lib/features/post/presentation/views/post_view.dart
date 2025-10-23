import 'package:flutter/material.dart';

import 'widgets/post_view_body.dart';

class PostView extends StatelessWidget {
  const PostView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: PostViewBody());
  }
}
