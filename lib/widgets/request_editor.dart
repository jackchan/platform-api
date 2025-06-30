import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RequestEditor extends StatefulWidget {
  const RequestEditor({super.key});

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
      setState(() {
        _responseText = 'Please enter a valid URL.';
      });
      return;
    }

    Uri? uri;
    try {
      uri = Uri.parse(urlText);
    } catch (e) {
      setState(() {
        _responseText = 'Invalid URL format.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _responseText = null;
    });

    try {
      http.Response response;

      final headers = <String, String>{'Content-Type': 'application/json'};

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

      setState(() {
        _responseText = 'Status: ${response.statusCode}\n\nHeaders:\n${response.headers}\n\nBody:\n${response.body}';
      });
    } catch (e) {
      setState(() {
        _responseText = 'Error sending request:\n$e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row with Method dropdown and URL input
          Row(
            children: [
              // HTTP Method dropdown
              DropdownButton<String>(
                value: _selectedMethod,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedMethod = value;
                      // Clear body if method doesn't allow body
                      if (!_isBodyAllowed) {
                        _bodyController.clear();
                      }
                    });
                  }
                },
                items: _methods.map((method) => DropdownMenuItem(value: method, child: Text(method))).toList(),
              ),

              const SizedBox(width: 12),

              // Expanded URL input
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

              // Send button
              ElevatedButton(
                onPressed: _isLoading ? null : _sendRequest,
                child: _isLoading
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Send'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Body input (only enabled for methods that allow body)
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

          const SizedBox(height: 16),

          // Response display
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(6),
                color: Theme.of(context).colorScheme.background,
              ),
              child: SingleChildScrollView(
                child: Text(
                  _responseText ?? 'Response will appear here',
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
