import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../community/presentation/views_model/community_provider.dart';
import '../widgets/communities_listview.dart';

class SearchCommunityDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(onPressed: () => query = '', icon: const Icon(Icons.close_rounded))];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return BuildCommunities(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return BuildCommunities(query: query);
  }
}

class BuildCommunities extends StatelessWidget {
  const BuildCommunities({super.key, required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => ref
          .watch(searchCommunityProvider(query))
          .when(
            data: (communities) => CommunitiesListview(communities: communities),
            error: (error, stackTrace) =>
                const Center(child: Text('Something Wrong Happend, Please Try Again Later')),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
    );
  }
}
