import 'package:flutter/material.dart';
import 'package:platform_api/l10n/app_localizations.dart';

class HeaderBar extends StatelessWidget {
  final AppLocalizations loc;
  final void Function(Locale) onLocaleChange;
  final VoidCallback onThemeToggle;

  const HeaderBar({
    super.key,
    required this.loc,
    required this.onLocaleChange,
    required this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(loc.title, style: const TextStyle(fontSize: 18)),
          Row(
            children: [
              PopupMenuButton<Locale>(
                icon: const Icon(Icons.language),
                onSelected: onLocaleChange,
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: Locale('en'),
                    child: Text('English'),
                  ),
                  const PopupMenuItem(value: Locale('zh'), child: Text('中文')),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.brightness_6),
                tooltip: loc.switch_theme,
                onPressed: onThemeToggle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
