import 'package:flutter/material.dart';

class ResponseViewer extends StatelessWidget {
  /// HTTP status code (e.g. 200, 404)
  final int? statusCode;

  /// How long the request took
  final Duration? responseTime;

  /// Size of the response body in bytes
  final int? responseSize;

  /// The actual response payload
  final String? responseText;

  /// Whether the request is still in flight
  final bool isLoading;

  const ResponseViewer({
    Key? key,
    required this.statusCode,
    required this.responseTime,
    required this.responseSize,
    required this.responseText,
    required this.isLoading,
  }) : super(key: key);

  String _formatDuration(Duration? d) {
    if (d == null) return '--';
    return '${d.inMilliseconds} ms';
  }

  String _formatBytes(int? bytes) {
    if (bytes == null) return '--';
    if (bytes < 1024) return '${bytes} B';
    final kb = bytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
    return '${(kb / 1024).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        // ─── Top info bar ─────────────
        Container(
          width: double.infinity,
          color: theme.colorScheme.surfaceVariant,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: isLoading
              ? const Text('Loading…')
              : Row(
                  children: [
                    const Spacer(),
                    Text('Status: ${statusCode ?? "--"}'),
                    const SizedBox(width: 16),
                    Text('Time: ${_formatDuration(responseTime)}'),
                    const SizedBox(width: 16),
                    Text('Size: ${_formatBytes(responseSize)}'),
                  ],
                ),
        ),

        // ─── Divider ─────────────────
        Divider(height: 1, color: theme.dividerColor),

        // ─── Body ────────────────────
        Expanded(
          child: Container(
            color: theme.colorScheme.background,
            padding: const EdgeInsets.all(16),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Text(
                      responseText ?? 'Response will appear here',
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
