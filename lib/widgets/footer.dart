import 'package:flutter/material.dart';

class FooterBar extends StatelessWidget {
  const FooterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Row(
        children: [
          Text('Status: Ready', style: Theme.of(context).textTheme.labelSmall),
          const Spacer(),
          Text('v0.1.0', style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}
