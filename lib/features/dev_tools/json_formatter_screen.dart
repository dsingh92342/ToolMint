import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toolmint/core/theme.dart';
import 'package:toolmint/shared/widgets/glass_card.dart';
import 'package:toolmint/shared/widgets/premium_background.dart';

class JsonFormatterScreen extends StatefulWidget {
  const JsonFormatterScreen({super.key});

  @override
  State<JsonFormatterScreen> createState() => _JsonFormatterScreenState();
}

class _JsonFormatterScreenState extends State<JsonFormatterScreen> {
  final TextEditingController _controller = TextEditingController();
  String _error = '';

  void _formatJson() {
    try {
      final jsonObject = json.decode(_controller.text);
      final prettyString = const JsonEncoder.withIndent('  ').convert(jsonObject);
      setState(() {
        _controller.text = prettyString;
        _error = '';
      });
    } catch (e) {
      setState(() {
        _error = 'Invalid JSON: $e';
      });
    }
  }

  void _minifyJson() {
    try {
      final jsonObject = json.decode(_controller.text);
      final minifiedString = json.encode(jsonObject);
      setState(() {
        _controller.text = minifiedString;
        _error = '';
      });
    } catch (e) {
      setState(() {
        _error = 'Invalid JSON: $e';
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JSON Formatter'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PremiumBackground(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              _buildControlBar(),
              const SizedBox(height: 20),
              Expanded(child: _buildInputFields()),
              if (_error.isNotEmpty) _buildErrorCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildActionButton('Format', Icons.format_align_left, _formatJson, AppTheme.primaryColor),
          const SizedBox(width: 12),
          _buildActionButton('Minify', Icons.compress, _minifyJson, Colors.white12),
          const SizedBox(width: 12),
          _buildActionButton('Copy', Icons.copy, () {
            Clipboard.setData(ClipboardData(text: _controller.text));
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied!')));
          }, Colors.white12),
          const SizedBox(width: 12),
          _buildActionButton('Clear', Icons.clear, () => _controller.clear(), Colors.white12),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onPressed, Color color) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildInputFields() {
    return GlassCard(
      child: TextField(
        controller: _controller,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: const TextStyle(fontFamily: 'Courier', fontSize: 13),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Paste your JSON here...',
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _error,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
