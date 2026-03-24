import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toolmint/core/theme.dart';
import 'package:toolmint/features/password_gen/password_provider.dart';
import 'package:toolmint/shared/widgets/glass_card.dart';

class PasswordGenScreen extends ConsumerStatefulWidget {
  const PasswordGenScreen({super.key});

  @override
  ConsumerState<PasswordGenScreen> createState() => _PasswordGenScreenState();
}

class _PasswordGenScreenState extends ConsumerState<PasswordGenScreen> {
  String _generatedPassword = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generatePassword();
    });
  }

  void _generatePassword() {
    setState(() {
      _generatedPassword = ref.read(passwordProvider.notifier).generate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(passwordProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Generator'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildResultCard(context),
            const SizedBox(height: 32),
            _buildSettingsCard(context, settings),
            const SizedBox(height: 40),
            _buildGenerateButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _generatedPassword,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontFamily: 'Courier',
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, color: Colors.white54),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _generatedPassword));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password copied to clipboard')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Keep it secure!',
            style: TextStyle(color: Colors.white24, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, PasswordSettings settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SETTINGS',
          style: TextStyle(
            color: Colors.white38,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        GlassCard(
          child: Column(
            children: [
              _buildSlider(context, settings),
              const Divider(color: Colors.white10),
              _buildSwitch(
                'Include Uppercase',
                settings.includeUppercase,
                (val) => ref.read(passwordProvider.notifier).toggleUppercase(val),
              ),
              _buildSwitch(
                'Include Numbers',
                settings.includeNumbers,
                (val) => ref.read(passwordProvider.notifier).toggleNumbers(val),
              ),
              _buildSwitch(
                'Include Symbols',
                settings.includeSymbols,
                (val) => ref.read(passwordProvider.notifier).toggleSymbols(val),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSlider(BuildContext context, PasswordSettings settings) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Length'),
            Text(
              '${settings.length}',
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: settings.length.toDouble(),
          min: 6,
          max: 32,
          divisions: 26,
          activeColor: AppTheme.primaryColor,
          thumbColor: AppTheme.primaryColor,
          onChanged: (val) => ref.read(passwordProvider.notifier).setLength(val),
        ),
      ],
    );
  }

  Widget _buildSwitch(String label, bool value, Function(bool?) onChanged) {
    return SwitchListTile(
      title: Text(label, style: const TextStyle(fontSize: 14)),
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppTheme.primaryColor,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildGenerateButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 10,
          shadowColor: AppTheme.primaryColor.withValues(alpha: 0.5),
        ),
        onPressed: _generatePassword,
        child: const Text(
          'GENERATE',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
