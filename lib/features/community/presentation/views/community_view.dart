import 'package:flutter/material.dart';

import 'widgets/community_view_body.dart';

class CommunityView extends StatelessWidget {
  final String name;
  const CommunityView({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: CommunityViewBody(name: name));
  }
}
