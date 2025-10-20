import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../auth/presentation/views_model/auth_provider.dart';
import '../../views_model/community_provider.dart';

class AddMods extends ConsumerStatefulWidget {
  final String name;
  const AddMods({super.key, required this.name});

  @override
  ConsumerState<AddMods> createState() => _AddModsState();
}

class _AddModsState extends ConsumerState<AddMods> {
  Set<String> uids = {};
  int counter = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => ref
                .watch(communityNotifierProvider.notifier)
                .addMods(widget.name, uids.toList(), context),
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: ref
          .watch(getCommunityProvider(widget.name))
          .when(
            data: (community) => ListView.builder(
              itemCount: community.members.length,
              itemBuilder: (context, index) => ref
                  .watch(getUserProvider(community.members[index]))
                  .when(
                    data: (user) {
                      if (community.mods.contains(user.uid) && counter == 0) {
                        uids.add(user.uid);
                      }
                      counter++;
                      return CheckboxListTile(
                        value: uids.contains(user.uid),
                        onChanged: (value) {
                          if (value!) {
                            setState(() {
                              uids.add(user.uid);
                            });
                          } else {
                            setState(() {
                              uids.remove(user.uid);
                            });
                          }
                        },
                        secondary: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(user.profile),
                        ),
                        title: Text(user.name),
                      );
                    },
                    error: (error, stackTrace) => const Center(
                      child: Text('Something Wrong Happend, Please Try Again Later'),
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                  ),
            ),
            error: (error, stackTrace) =>
                const Center(child: Text('Something Wrong Happend, Please Try Again Later')),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
    );
  }
}
