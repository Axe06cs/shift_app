import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const ShiftApp());
}

class ShiftApp extends StatelessWidget {
  const ShiftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shift Converter',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const ConverterPage(),
    );
  }
}

/// Direct translation of the C `convert()` function: a fixed,
/// self-inverse character swap table. Characters not listed pass through
/// unchanged.
String convertChar(String c) {
  const map = {
    '5': 'a', 'a': '5',
    '4': 'b', 'b': '4',
    '3': 'c', 'c': '3',
    '2': 'd', 'd': '2',
    '1': 'e', 'e': '1',
    '0': 'f', 'f': '0',
    '7': '8', '8': '7',
    '9': '6', '6': '9',
  };
  return map[c] ?? c;
}

/// Direct translation of the C `main()` transform logic:
/// - if the input starts with "fh_", strip that prefix and prepend "wlan"
/// - convert every remaining character through convertChar
String transform(String input) {
  const prefix = 'fh_';
  final hasPrefix = input.startsWith(prefix);
  final body = hasPrefix ? input.substring(prefix.length) : input;

  final buffer = StringBuffer();
  if (hasPrefix) buffer.write('wlan');
  for (final c in body.split('')) {
    buffer.write(convertChar(c));
  }
  return buffer.toString();
}

class ConverterPage extends StatefulWidget {
  const ConverterPage({super.key});

  @override
  State<ConverterPage> createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  final TextEditingController _inputController = TextEditingController();
  String _output = '';

  void _onChanged(String value) {
    setState(() {
      _output = transform(value);
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shift Converter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Input', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _inputController,
              maxLines: 4,
              onChanged: _onChanged,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Type or paste text here',
              ),
            ),
            const SizedBox(height: 24),
            const Text('Output', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: TextEditingController(text: _output),
              maxLines: 4,
              readOnly: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy output'),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _output));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear'),
                    onPressed: () {
                      _inputController.clear();
                      setState(() => _output = '');
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
