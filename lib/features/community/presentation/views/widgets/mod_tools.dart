import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModTools extends StatelessWidget {
  final String name;
  const ModTools({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mod Tools')),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.add_moderator_rounded),
            title: const Text('Add Moderators'),
            onTap: () => Routemaster.of(context).push('/add-mods/$name'),
          ),
          ListTile(
            leading: const Icon(Icons.edit_note_rounded),
            title: const Text('Edit Community'),
            onTap: () => Routemaster.of(context).push('/edit-community/$name'),
          ),
        ],
      ),
    );
  }
}
