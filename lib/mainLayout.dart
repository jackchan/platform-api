import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'widgets/left_side_bar.dart';
import 'widgets/header_bar.dart';
import 'widgets/footer.dart';
import 'widgets/main_panel.dart';

class MainLayout extends StatelessWidget {
  final void Function(Locale) onLocaleChange;
  final VoidCallback onThemeToggle;

  const MainLayout({
    super.key,
    required this.onLocaleChange,
    required this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: Column(
        children: [
          HeaderBar(
            loc: loc,
            onLocaleChange: onLocaleChange,
            onThemeToggle: onThemeToggle,
          ),
          Expanded(
            child: Row(
              children: const [
                LeftSidebar(),
                Expanded(child: MainPanel()),
              ],
            ),
          ),
          const FooterBar(),
        ],
      ),
    );
  }
}
