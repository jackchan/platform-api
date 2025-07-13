import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String appVersion = dotenv.env['APP_VERSION'] ?? '';

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
          Text('v$appVersion', style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}
