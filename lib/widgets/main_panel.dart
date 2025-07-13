// lib/main_panel.dart

import 'package:flutter/material.dart';
import 'request_editor.dart';
import 'response_viewer.dart';

class MainPanel extends StatefulWidget {
  const MainPanel({Key? key}) : super(key: key);

  @override
  State<MainPanel> createState() => _MainPanelState();
}

class _MainPanelState extends State<MainPanel> {
  // split ratio for draggable panes
  double _splitRatio = 0.5;
  static const double _dividerHeight = 8.0;

  // === Response state ===
  int? _statusCode;
  Duration? _responseTime;
  int? _responseSize;
  String? _responseText;
  bool _isLoading = false;

  void _onDrag(DragUpdateDetails details, double maxHeight) {
    setState(() {
      _splitRatio += details.delta.dy / maxHeight;
      _splitRatio = _splitRatio.clamp(0.1, 0.9);
    });
  }

  // Callback from RequestEditor:
  void _handleResponse({
    String? response,
    bool? loading,
    // you could extend this to include statusCode, responseTime, responseSize
  }) {
    setState(() {
      if (response != null) _responseText = response;
      if (loading != null) _isLoading = loading;

      // if the request just finished, you could also set these:
      if (loading == false && response != null) {
        // for now we leave metrics null—you can calculate & set these in RequestEditor
        _statusCode = null;
        _responseTime = null;
        _responseSize = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalHeight = constraints.maxHeight;
        final topHeight = totalHeight * _splitRatio;
        final bottomHeight = totalHeight - topHeight - _dividerHeight;

        return Column(
          children: [
            // ─── Top pane: Request form ───────────────────────
            SizedBox(
              height: topHeight,
              child: RequestEditor(onResponseChanged: _handleResponse),
            ),

            // ─── Draggable divider ───────────────────────────
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onVerticalDragUpdate: (details) => _onDrag(details, totalHeight),
              child: Container(
                height: _dividerHeight,
                color: Theme.of(context).dividerColor,
                child: const Center(child: Icon(Icons.drag_handle, size: 16, color: Colors.grey)),
              ),
            ),

            // ─── Bottom pane: Response viewer ─────────────────
            SizedBox(
              height: bottomHeight,
              child: ResponseViewer(
                statusCode: _statusCode,
                responseTime: _responseTime,
                responseSize: _responseSize,
                responseText: _responseText,
                isLoading: _isLoading,
              ),
            ),
          ],
        );
      },
    );
  }
}
