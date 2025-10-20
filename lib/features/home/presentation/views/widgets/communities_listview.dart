import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../../core/models/community_model.dart';

class CommunitiesListview extends StatelessWidget {
  final List<CommunityModel> communities;
  const CommunitiesListview({super.key, required this.communities});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: communities.length,
      itemBuilder: (context, index) => ListTile(
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(communities[index].avatar),
        ),
        title: Text('r/${communities[index].name}'),
        onTap: () => Routemaster.of(context).push('/r/${communities[index].name}'),
      ),
    );
  }
}
