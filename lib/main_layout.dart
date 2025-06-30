import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'widgets/left_side_bar.dart';
import 'widgets/header_bar.dart';
import 'widgets/footer.dart';
import 'widgets/main_panel.dart';

class MainLayout extends StatefulWidget {
  final void Function(Locale) onLocaleChange;
  final VoidCallback onThemeToggle;

  const MainLayout({super.key, required this.onLocaleChange, required this.onThemeToggle});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  // Width when expanded
  double sidebarWidth = 250;

  // Minimum expanded width before collapse
  final double minExpandedWidth = 200;

  // Width when collapsed (narrow sidebar)
  final double collapsedWidth = 50;

  final double maxSidebarWidth = 500;
  bool isDragging = false;

  // Whether sidebar is collapsed
  bool isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    // Sidebar width depends on collapsed state
    final currentSidebarWidth = isCollapsed ? collapsedWidth : sidebarWidth;

    return Scaffold(
      body: Column(
        children: [
          HeaderBar(loc: loc, onLocaleChange: widget.onLocaleChange, onThemeToggle: widget.onThemeToggle),
          Expanded(
            child: Row(
              children: [
                SizedBox(width: currentSidebarWidth, child: const LeftSidebar()),
                // Draggable divider for resizing
                MouseRegion(
                  cursor: SystemMouseCursors.resizeColumn,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onHorizontalDragStart: (_) {
                      setState(() => isDragging = true);
                    },
                    onHorizontalDragUpdate: (details) {
                      setState(() {
                        double newWidth = currentSidebarWidth + details.delta.dx;

                        if (isCollapsed) {
                          // If collapsed, dragging right expands sidebar immediately
                          if (newWidth > collapsedWidth + 20) {
                            isCollapsed = false;
                            sidebarWidth = minExpandedWidth;
                          }
                        } else {
                          // Sidebar expanded - allow resizing with limits
                          if (newWidth < minExpandedWidth) {
                            // Collapse if smaller than minExpandedWidth
                            isCollapsed = true;
                          } else if (newWidth > maxSidebarWidth) {
                            sidebarWidth = maxSidebarWidth;
                          } else {
                            sidebarWidth = newWidth;
                          }
                        }
                      });
                    },
                    onHorizontalDragEnd: (_) {
                      setState(() => isDragging = false);
                    },
                    child: Container(
                      width: 5,
                      color: isDragging ? Colors.blueAccent.withOpacity(0.7) : Colors.transparent,
                    ),
                  ),
                ),
                const Expanded(child: MainPanel()),
              ],
            ),
          ),
          const FooterBar(),
        ],
      ),
    );
  }
}
