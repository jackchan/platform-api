import 'package:flutter/material.dart';

class LeftSidebar extends StatelessWidget {
  const LeftSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: ListView(
        children: const [
          ListTile(leading: Icon(Icons.history), title: Text('History')),
          ListTile(leading: Icon(Icons.folder), title: Text('Collections')),
          Divider(),
          ListTile(leading: Icon(Icons.settings), title: Text('Environment')),
        ],
      ),
    );
  }
}
