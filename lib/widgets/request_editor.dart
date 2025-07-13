import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

typedef ResponseCallback = void Function({String? response, bool? loading});

class RequestEditor extends StatefulWidget {
  final ResponseCallback onResponseChanged;

  const RequestEditor({Key? key, required this.onResponseChanged}) : super(key: key);

  @override
  State<RequestEditor> createState() => _RequestEditorState();
}

class _RequestEditorState extends State<RequestEditor> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  String _selectedMethod = 'GET';
  String? _responseText;
  bool _isLoading = false;

  final List<String> _methods = ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'];

  @override
  void dispose() {
    _urlController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  bool get _isBodyAllowed => ['POST', 'PUT', 'PATCH'].contains(_selectedMethod);

  Future<void> _sendRequest() async {
    final urlText = _urlController.text.trim();
    if (urlText.isEmpty) {
      _updateResponse('Please enter a valid URL.', false);
      return;
    }

    Uri uri;
    try {
      uri = Uri.parse(urlText);
    } catch (_) {
      _updateResponse('Invalid URL format.', false);
      return;
    }

    _updateResponse(null, true);

    try {
      final headers = {'Content-Type': 'application/json'};
      late final http.Response response;

      switch (_selectedMethod) {
        case 'GET':
          response = await http.get(uri);
          break;
        case 'POST':
          response = await http.post(uri, headers: headers, body: _bodyController.text);
          break;
        case 'PUT':
          response = await http.put(uri, headers: headers, body: _bodyController.text);
          break;
        case 'DELETE':
          response = await http.delete(uri);
          break;
        case 'PATCH':
          response = await http.patch(uri, headers: headers, body: _bodyController.text);
          break;
        default:
          throw UnsupportedError('Method $_selectedMethod not supported');
      }

      _updateResponse(
        'Status: ${response.statusCode}\n\n'
        'Headers:\n${response.headers}\n\n'
        'Body:\n${response.body}',
        false,
      );
    } catch (e) {
      _updateResponse('Error sending request:\n$e', false);
    }
  }

  void _updateResponse(String? text, bool loading) {
    setState(() {
      _responseText = text;
      _isLoading = loading;
    });
    widget.onResponseChanged(response: text, loading: loading);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Method + URL row
          Row(
            children: [
              DropdownButton<String>(
                value: _selectedMethod,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedMethod = value;
                    if (!_isBodyAllowed) _bodyController.clear();
                  });
                },
                items: _methods.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _urlController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Request URL',
                    hintText: 'https://api.example.com/v1/users',
                  ),
                  keyboardType: TextInputType.url,
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _isLoading ? null : _sendRequest,
                child: _isLoading
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Send'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Body input
          TextField(
            controller: _bodyController,
            enabled: _isBodyAllowed,
            maxLines: 8,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Request Body',
              hintText: _isBodyAllowed
                  ? 'Enter request payload here (JSON, text, etc.)'
                  : 'Request body not allowed for $_selectedMethod',
            ),
          ),
        ],
      ),
    );
  }
}
