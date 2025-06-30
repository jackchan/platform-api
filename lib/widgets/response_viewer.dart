import 'package:flutter/material.dart';

class ResponseViewer extends StatelessWidget {
  const ResponseViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.background,
      child: const Center(child: Text('Response Viewer')),
    );
  }
}
