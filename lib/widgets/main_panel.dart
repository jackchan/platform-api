import 'package:flutter/material.dart';
import 'request_editor.dart';
import 'response_viewer.dart';

class MainPanel extends StatelessWidget {
  const MainPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Expanded(flex: 1, child: RequestEditor()),
        Divider(height: 1),
        Expanded(flex: 1, child: ResponseViewer()),
      ],
    );
  }
}
