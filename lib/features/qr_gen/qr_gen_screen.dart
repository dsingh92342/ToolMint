import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:toolmint/core/theme.dart';
import 'package:toolmint/shared/widgets/glass_card.dart';

class QRGenScreen extends StatefulWidget {
  const QRGenScreen({super.key});

  @override
  State<QRGenScreen> createState() => _QRGenScreenState();
}

class _QRGenScreenState extends State<QRGenScreen> {
  final TextEditingController _controller = TextEditingController(text: 'https://toolmint.com');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Generator'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildQRContainer(context),
            const SizedBox(height: 32),
            _buildInputCard(context),
            const SizedBox(height: 40),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildQRContainer(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(16),
          child: QrImageView(
            data: _controller.text.isEmpty ? ' ' : _controller.text,
            version: QrVersions.auto,
            size: 200.0,
            gapless: false,
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'INPUT CONTENT',
          style: TextStyle(
            color: Colors.white38,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        GlassCard(
          child: TextField(
            controller: _controller,
            maxLines: 3,
            style: const TextStyle(fontSize: 16),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter text or URL here...',
            ),
            onChanged: (val) => setState(() {}),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.copy),
            label: const Text('COPY LINK'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white12,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            onPressed: () {
              // Copy logic
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.download),
            label: const Text('SAVE QR'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            onPressed: () {
              // Save logic (would need path_provider and gallery_saver)
            },
          ),
        ),
      ],
    );
  }
}
