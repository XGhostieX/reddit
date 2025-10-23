import 'package:flutter/material.dart';

import 'widgets/feed_view_body.dart';

class FeedView extends StatelessWidget {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: FeedViewBody());
  }
}
