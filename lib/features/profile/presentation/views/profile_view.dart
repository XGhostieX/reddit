import 'package:flutter/material.dart';

import 'widgets/profile_view_body.dart';

class ProfileView extends StatelessWidget {
  final String uid;

  const ProfileView({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ProfileViewBody(uid: uid));
  }
}
